local params = import "../../components/params.libsonnet";
params + {
  components +: {
    // Insert component parameter overrides here. Ex:
    // guestbook +: {
    //   name: "guestbook-dev",
    //   replicas: params.global.replicas,
    // },
    "guestbook-ui" +: {
      image: "gcr.io/heptio-images/ks-guestbook-demo:0.2",
    },
  },
}
