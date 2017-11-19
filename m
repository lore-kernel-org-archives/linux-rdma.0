From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH rdma-next 28/31] IB/cm: Fix avoid sleep while spin lock is
 held
Date: Sun, 19 Nov 2017 08:42:17 +0000
Message-ID: <BN3PR07MB2578DF2F9081ED97D5A4351EF82D0@BN3PR07MB2578.namprd07.prod.outlook.com>
References: <20171114125218.20477-1-leon@kernel.org>
 <20171114125218.20477-29-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114125218.20477-29-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> In case of LAP are used for RoCE, it can lead to a problem of sleeping a
> context while spin lock is held in below flow.
>=20
> cm_lap_handler
> 	->spin_lock
> 	-> <..switch_case..>
> 	-> cm_init_av_for_response
> 		-> ib_init_ah_from_wc
> 			-> rdma_addr_find_l2_eth_by_grh
> 				wait_for_completion()
>=20
> Therefore ah attribute initialization is done for incoming lap requests
> outside of the lock context.
>=20
> Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Should you add a "Fixes:..."?
Pardon my ignorance, but what is LAP?

Thanks,
Ram

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
