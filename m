From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v3 for-next 01/33] IB/core: Add RoCE GID cache
Date: Wed, 15 Apr 2015 16:08:25 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FC19D9@ORSMSX109.amr.corp.intel.com>
References: <1427318422-12004-1-git-send-email-somnath.kotur@emulex.com>
 <44ab0dce-c7c9-400b-af24-10b8981358a7@CMEXHTCAS2.ad.emulex.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FBE792@ORSMSX109.amr.corp.intel.com>
 <7F44EA5110810A40B7DAFB605C41975D58F98121@CMEXMB1.ad.emulex.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FC0C00@ORSMSX109.amr.corp.intel.com>
 <552CDEA5.6020709@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FC11F3@ORSMSX109.amr.corp.intel.com>
 <7F44EA5110810A40B7DAFB605C41975D58FA0B05@CMEXMB1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7F44EA5110810A40B7DAFB605C41975D58FA0B05-DWYeeINJQrxExQ8dmkPuX0M9+F4ksjoh@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Somnath Kotur <Somnath.Kotur-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> It does not  break every app, the choice of which GID type to use is made
> by the RDMA-CM based on network topology hint obtained from the IP stack.
> Please refer to patch 15/33: IB/Core: Changes to the IB Core
> infrastructure for RoCEv2 support.
> Of course, if the user does not want to go with this choice made by the
> RDMA-CM, then there is the option of overriding it using the configfs
> patch (PATCH 14/33)
> Hope that clarifies?

RoCE v2 is really Infiniband over UDP over IP.  Why don't we just call it IBoUDP like it is?

IBoUDP changes the Ethertype, replaces the network header, adds a new transport protocol header, and layers IB over that.  This change should be exposed properly and not as just a new GID type.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
