import { Logger as __Logger } from "@aws-sdk/types";
import { parseUrl } from "@aws-sdk/url-parser";

import { AmplifyUIBuilderClientConfig } from "./AmplifyUIBuilderClient";
import { defaultRegionInfoProvider } from "./endpoints";

/**
 * @internal
 */
export const getRuntimeConfig = (config: AmplifyUIBuilderClientConfig) => ({
  apiVersion: "2021-08-11",
  disableHostPrefix: config?.disableHostPrefix ?? false,
  logger: config?.logger ?? ({} as __Logger),
  regionInfoProvider: config?.regionInfoProvider ?? defaultRegionInfoProvider,
  serviceId: config?.serviceId ?? "AmplifyUIBuilder",
  urlParser: config?.urlParser ?? parseUrl,
});