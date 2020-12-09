class Tendencia_Cormoran_Pacifico:

    def set_islet(self, islet):
        plot_data = cormorant_data[cormorant_data.Isla == islet]
        self.plot_data = plot_data
    
    def set_season(self):
        season = plot_data["Intervalo"].str.split("-", n=1, expand=True)
        plot_data["Temporada"] = season[0].astype("int32")
        plot_data = plot_data.rename(columns={"Nidos_activos_por_visita": "Maxima_cantidad_nidos"})
        plot_data = plot_data.reset_index(drop=True)

        ticks_text = plot_data.Intervalo.unique()
        ticks_positions = ticks_positions_array(ticks_text)

    def calculate_trends(self):
        plot_data = plot_data.dropna(subset=["Maxima_cantidad_nidos"])
        min_value = plot_data["Maxima_cantidad_nidos"].min()
        max_value = plot_data["Maxima_cantidad_nidos"].max()
        time_fit = np.array(plot_data.index) + 1
        time_to_model = np.linspace(time_fit.min(), time_fit.max(), 100)

        parameters = lambda_calculator(plot_data["Temporada"], plot_data["Maxima_cantidad_nidos"])
        lambdas_distribution, intervals = bootstrap_from_time_series(
            plot_data,
            "Maxima_cantidad_nidos",
            N=20,
            return_distribution=True,
            remove_outliers=True,
        )

    def plot_trend(self):
        lambdas_distribution = pd.DataFrame({"Tasa de crecimiento": lambdas_distribution})
        p_value_mayor, p_value_menor = calculate_p_values(lambdas_distribution)

        lambda_latex = generate_latex_interval_string(intervals)

        lambdas_results.append([islet, lambda_latex, p_value_mayor, p_value_menor])

        model_min = power_law(time_to_model, intervals[0], parameters[1])
        model_med = power_law(time_to_model, intervals[1], parameters[1])
        model_max = power_law(time_to_model, intervals[2], parameters[1])
