From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 03/14] RDMA/bnxt_re: Fix race between netdev
 register and unregister events
Date: Thu, 18 May 2017 07:31:00 +0300
Message-ID: <20170518043100.GV3616@mtr-leonro.local>
References: <1494413139-11883-1-git-send-email-selvin.xavier@broadcom.com>
 <1494413139-11883-4-git-send-email-selvin.xavier@broadcom.com>
 <20170514064904.GR3616@mtr-leonro.local>
 <CA+sbYW0LLrE7EAsa1C-Bza1e6ug2MYntk8YVdOgm=iBLqDKBHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Zz5hxuHUV8Fb7Aol"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+sbYW0LLrE7EAsa1C-Bza1e6ug2MYntk8YVdOgm=iBLqDKBHw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Zz5hxuHUV8Fb7Aol
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 15, 2017 at 04:24:54PM +0530, Selvin Xavier wrote:
> On Sun, May 14, 2017 at 12:19 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > On Wed, May 10, 2017 at 03:45:28AM -0700, Selvin Xavier wrote:
> >> From: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> >>
> >> Upon receipt of the NETDEV_REGISTER event from the netdev notifier
> >> chain, the IB stack registration is spawned off to a workqueue
> >> since that also requires an rtnl lock.
> >> There could be 2 kinds of races between the NETDEV_REGISTER and the
> >> NETDEV_UNREGISTER event handling.
> >> a)The NETDEV_UNREGISTER event is received in rapid succession after
> >> the NETDEV_REGISTER event even before the work queue got a chance
> >> to run
> >> b)The NETDEV_UNREGISTER event is received while the workqueue that
> >> handles registration with the IB stack is still in progress.
> >> Handle both the races with a bit flag that is set as part of the
> >> NETDEV_REGISTER event just before the work item is queued and cleared
> >> in the workqueue after the registration with the IB stack is complete.
> >> Use a barrier to ensure the bit is cleared only after the IB stack
> >> registration code is completed.
> >
> > I have a very strong feeling that this patch doesn't solve race, but
> > makes it is hard to reproduce. Why don't you use locks to protect flows?
> >
>
> IB registration cannot be invoked from the netdev event because the IB stack
> tries to acquire the rtnl_lock and netdev event is already in rtnl
> lock context. So we
> are scheduling a worker in case of NETDEV_REGISTER.
> From the worker task, bnxt_re driver tries to acquire rtnl_lock to access
> the L2 driver for creating the initial resources.
>
> Having a driver lock to synchronize does not solve the possible dead
> lock situation.
> Say, in case the driver acquired the driver_lock in the registration task and a
> NETDEV_UNREGISTER is received which comes with rtnl_lock is held.
> Driver tries to acquire the driver_lock during un-reg. However,
> registration task will hold
> the driver_lock and wait for rtnl_lock to access the L2 driver. netdev
> unreg event will not
> get the driver_lock.
>
> To avoid this dead lock, we are using BNXT_RE_FLAG_NETDEV_REG_IN_PROG and
> driver doesn't decrement the netdev ref count if the registration task
> is running. Once registration
> is done, we will reset BNXT_RE_FLAG_NETDEV_REG_IN_PROG flag and we will proceed
> with un-registration.

It doesn't answer to my question, but whatever, it is not critical.

Thanks

>
>
> >>
> >> Removes the link speed query from the query_port as it causes
> >> deadlock while trying to acquire rtnl_lock. Now querying the
> >> speed from the nedev event itself.
> >>
> >> Also, added a code to wait for resources(like CQ) to be freed by the
> >> ULPs, during driver unload
> >>
> >> Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> >> Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> >> Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> >> ---
> >>  drivers/infiniband/hw/bnxt_re/bnxt_re.h  | 13 +++++++----
> >>  drivers/infiniband/hw/bnxt_re/ib_verbs.c | 21 +++--------------
> >>  drivers/infiniband/hw/bnxt_re/main.c     | 39 ++++++++++++++++++++++++++++++++
> >>  3 files changed, 50 insertions(+), 23 deletions(-)
> >>
> >> diff --git a/drivers/infiniband/hw/bnxt_re/bnxt_re.h b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
> >> index ebf7be8..fad04b2 100644
> >> --- a/drivers/infiniband/hw/bnxt_re/bnxt_re.h
> >> +++ b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
> >> @@ -80,11 +80,13 @@ struct bnxt_re_dev {
> >>       struct ib_device                ibdev;
> >>       struct list_head                list;
> >>       unsigned long                   flags;
> >> -#define BNXT_RE_FLAG_NETDEV_REGISTERED       0
> >> -#define BNXT_RE_FLAG_IBDEV_REGISTERED        1
> >> -#define BNXT_RE_FLAG_GOT_MSIX                2
> >> -#define BNXT_RE_FLAG_RCFW_CHANNEL_EN 8
> >> -#define BNXT_RE_FLAG_QOS_WORK_REG    16
> >> +#define BNXT_RE_FLAG_NETDEV_REGISTERED         0
> >> +#define BNXT_RE_FLAG_IBDEV_REGISTERED          1
> >> +#define BNXT_RE_FLAG_GOT_MSIX                  2
> >> +#define BNXT_RE_FLAG_RCFW_CHANNEL_EN           4
> >> +#define BNXT_RE_FLAG_QOS_WORK_REG              5
> >> +#define BNXT_RE_FLAG_NETDEV_REG_IN_PROG        6
> >> +
> >>       struct net_device               *netdev;
> >>       unsigned int                    version, major, minor;
> >>       struct bnxt_en_dev              *en_dev;
> >> @@ -127,6 +129,7 @@ struct bnxt_re_dev {
> >>       struct bnxt_re_qp               *qp1_sqp;
> >>       struct bnxt_re_ah               *sqp_ah;
> >>       struct bnxt_re_sqp_entries sqp_tbl[1024];
> >> +     u32 espeed;
> >>  };
> >>
> >>  #define to_bnxt_re_dev(ptr, member)  \
> >> diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> >> index 6385213..c717d5d 100644
> >> --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> >> +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> >> @@ -223,20 +223,8 @@ int bnxt_re_modify_device(struct ib_device *ibdev,
> >>       return 0;
> >>  }
> >>
> >> -static void __to_ib_speed_width(struct net_device *netdev, u8 *speed, u8 *width)
> >> +static void __to_ib_speed_width(u32 espeed, u8 *speed, u8 *width)
> >>  {
> >> -     struct ethtool_link_ksettings lksettings;
> >> -     u32 espeed;
> >> -
> >> -     if (netdev->ethtool_ops && netdev->ethtool_ops->get_link_ksettings) {
> >> -             memset(&lksettings, 0, sizeof(lksettings));
> >> -             rtnl_lock();
> >> -             netdev->ethtool_ops->get_link_ksettings(netdev, &lksettings);
> >> -             rtnl_unlock();
> >> -             espeed = lksettings.base.speed;
> >> -     } else {
> >> -             espeed = SPEED_UNKNOWN;
> >> -     }
> >>       switch (espeed) {
> >>       case SPEED_1000:
> >>               *speed = IB_SPEED_SDR;
> >> @@ -303,12 +291,9 @@ int bnxt_re_query_port(struct ib_device *ibdev, u8 port_num,
> >>       port_attr->sm_sl = 0;
> >>       port_attr->subnet_timeout = 0;
> >>       port_attr->init_type_reply = 0;
> >> -     /* call the underlying netdev's ethtool hooks to query speed settings
> >> -      * for which we acquire rtnl_lock _only_ if it's registered with
> >> -      * IB stack to avoid race in the NETDEV_UNREG path
> >> -      */
> >> +
> >>       if (test_bit(BNXT_RE_FLAG_IBDEV_REGISTERED, &rdev->flags))
> >> -             __to_ib_speed_width(rdev->netdev, &port_attr->active_speed,
> >> +             __to_ib_speed_width(rdev->espeed, &port_attr->active_speed,
> >>                                   &port_attr->active_width);
> >>       return 0;
> >>  }
> >> diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
> >> index 5d35540..99a54fd 100644
> >> --- a/drivers/infiniband/hw/bnxt_re/main.c
> >> +++ b/drivers/infiniband/hw/bnxt_re/main.c
> >> @@ -48,6 +48,8 @@
> >>  #include <net/ipv6.h>
> >>  #include <net/addrconf.h>
> >>  #include <linux/if_ether.h>
> >> +#include <linux/atomic.h>
> >> +#include <asm/barrier.h>
> >>
> >>  #include <rdma/ib_verbs.h>
> >>  #include <rdma/ib_user_verbs.h>
> >> @@ -926,6 +928,10 @@ static void bnxt_re_ib_unreg(struct bnxt_re_dev *rdev, bool lock_wait)
> >>       if (test_and_clear_bit(BNXT_RE_FLAG_QOS_WORK_REG, &rdev->flags))
> >>               cancel_delayed_work(&rdev->worker);
> >>
> >> +     /* Wait for ULPs to release references */
> >> +     while (atomic_read(&rdev->cq_count))
> >> +             usleep_range(500, 1000);
> >> +
> >
> > It can change immediately after your check.
> [Selvin] Yeah. We might end up waiting for 1ms in the unload path. We
> have kept this change, since it
> is a control path operation.
> >
> >>       bnxt_re_cleanup_res(rdev);
> >>       bnxt_re_free_res(rdev, lock_wait);
> >>
> >> @@ -1152,6 +1158,22 @@ static void bnxt_re_remove_one(struct bnxt_re_dev *rdev)
> >>       pci_dev_put(rdev->en_dev->pdev);
> >>  }
> >>
> >> +static void bnxt_re_get_link_speed(struct bnxt_re_dev *rdev)
> >> +{
> >> +     struct ethtool_link_ksettings lksettings;
> >> +     struct net_device *netdev = rdev->netdev;
> >> +
> >> +     if (netdev->ethtool_ops && netdev->ethtool_ops->get_link_ksettings) {
> >> +             memset(&lksettings, 0, sizeof(lksettings));
> >> +             if (rtnl_trylock()) {
> >> +                     netdev->ethtool_ops->get_link_ksettings(netdev,
> >> +                                                             &lksettings);
> >> +                     rdev->espeed = lksettings.base.speed;
> >> +                     rtnl_unlock();
> >> +             }
> >> +     }
> >> +}
> >> +
> >>  /* Handle all deferred netevents tasks */
> >>  static void bnxt_re_task(struct work_struct *work)
> >>  {
> >> @@ -1169,6 +1191,10 @@ static void bnxt_re_task(struct work_struct *work)
> >>       switch (re_work->event) {
> >>       case NETDEV_REGISTER:
> >>               rc = bnxt_re_ib_reg(rdev);
> >> +             /* Use memory barrier to sync the rdev->flags */
> >> +             smp_mb();
> >> +             clear_bit(BNXT_RE_FLAG_NETDEV_REG_IN_PROG,
> >> +                       &rdev->flags);
> >>               if (rc)
> >>                       dev_err(rdev_to_dev(rdev),
> >>                               "Failed to register with IB: %#x", rc);
> >> @@ -1186,6 +1212,7 @@ static void bnxt_re_task(struct work_struct *work)
> >>               else if (netif_carrier_ok(rdev->netdev))
> >>                       bnxt_re_dispatch_event(&rdev->ibdev, NULL, 1,
> >>                                              IB_EVENT_PORT_ACTIVE);
> >> +             bnxt_re_get_link_speed(rdev);
> >>               break;
> >>       default:
> >>               break;
> >> @@ -1244,10 +1271,22 @@ static int bnxt_re_netdev_event(struct notifier_block *notifier,
> >>                       break;
> >>               }
> >>               bnxt_re_init_one(rdev);
> >> +             /*
> >> +              *  Query the link speed at the time of registration.
> >> +              *  Already in rtnl_lock context
> >> +              */
> >> +             bnxt_re_get_link_speed(rdev);
> >> +
> >> +             set_bit(BNXT_RE_FLAG_NETDEV_REG_IN_PROG, &rdev->flags);
> >>               sch_work = true;
> >>               break;
> >>
> >>       case NETDEV_UNREGISTER:
> >> +             /* netdev notifier will call NETDEV_UNREGISTER again later since
> >> +              * we are still holding the reference to the netdev
> >> +              */
> >> +             if (test_bit(BNXT_RE_FLAG_NETDEV_REG_IN_PROG, &rdev->flags))
> >> +                     goto exit;
> >>               bnxt_re_ib_unreg(rdev, false);
> >>               bnxt_re_remove_one(rdev);
> >>               bnxt_re_dev_unreg(rdev);
> >> --
> >> 2.5.5
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--Zz5hxuHUV8Fb7Aol
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkdI4QACgkQ5GN7iDZy
WKfMbRAAphMoTI9yGQi4IdpHki3VAte59lC9kW16nn86hO5Qmr7Lko/8GWs1xZEU
WZg0Ej7Ny0sGnUju2++ihsm3HnPJGG2w4YcFRCXSCkgTJI4Znwb0a9aIcZlj1nRd
rG0QaJwhgu8uOdxcYEF9YPaa6NQRssxTnScDNm9PMBSls1uFP0AzJXRIiBxF6uYt
uzWEwjh5w7tFqLB7fG5bV7iFpadY32Mr5LDqBndEl+13hVetEUFho/b4+4vjn1xa
J+XVnaA+qEnl4g5CKZRV9tcgs+qJzxD0FQDVcCmCBUumrftcEVCyPfx6sR5fWZzi
1u6bR7TU5a+XS7RKDAC2LISpzav19mKN01MkpXU3wTT0UQIQ2qTbmemSXyj5Ixlc
n//fYfE9MsldctDaZoaBEcPI2d3NN+eUAAWvBss6xi9M0ZFNX3ii4avAT4JSoG9o
reKw1CQLljQnqJDT6s3IkmktuO4RUotmcBzXAa78wjpe2dZN/gVxVvqNLHWYDGAq
7+eqMMnFcb/5dwM+Xm5pVacy2D2XySB7uk9PbKjmDLR/+Nz7xacSzs70VwKvDaOI
jPwLwUUWQlKi2KAZfHJpZP1Ezb8E8i6Y034NhgXenieh1FY6+3kHCWnlj2qoJRE4
saqWmu+MM/gjzaqN3MrxN1CFkYYAbawFMmvyhgygug+Rpucj3xU=
=x8Wy
-----END PGP SIGNATURE-----

--Zz5hxuHUV8Fb7Aol--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
