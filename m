From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 5/7] IB/mlx4: Enable send of RoCE QP1 packets
 with IP/UDP headers
Date: Tue, 29 Dec 2015 21:01:18 +0200
Message-ID: <CAJ3xEMgVvpj5S9gc_3onzCU5zjkXayOEZCCk_DofAwz194s8KQ@mail.gmail.com>
References: <1451395447-5198-1-git-send-email-matanb@mellanox.com>
	<1451395447-5198-6-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1451395447-5198-6-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 29, 2015 at 3:24 PM, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> @@ -2413,34 +2442,27 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_ud_wr *wr,
>
>         if (is_eth) {
>                 struct in6_addr in6;
> -
> +               u16 ether_type;
>                 u16 pcp = (be32_to_cpu(ah->av.ib.sl_tclass_flowlabel) >> 29) << 13;
>
> +               ether_type = (!is_udp) ? MLX4_IB_IBOE_ETHERTYPE :
> +                       (ip_version == 4 ? ETH_P_IP : ETH_P_IPV6);
> +
>                 mlx->sched_prio = cpu_to_be16(pcp);
>
> +               ether_addr_copy(sqp->ud_header.eth.smac_h, ah->av.eth.s_mac);
>                 memcpy(sqp->ud_header.eth.dmac_h, ah->av.eth.mac, 6);
> -               /* FIXME: cache smac value? */
>                 memcpy(&ctrl->srcrb_flags16[0], ah->av.eth.mac, 2);
>                 memcpy(&ctrl->imm, ah->av.eth.mac + 2, 4);
>                 memcpy(&in6, sgid.raw, sizeof(in6));
>
> -               if (!mlx4_is_mfunc(to_mdev(ib_dev)->dev)) {
> -                       u64 mac = atomic64_read(&to_mdev(ib_dev)->iboe.mac[sqp->qp.port - 1]);
> -                       u8 smac[ETH_ALEN];
> -
> -                       mlx4_u64_to_smac(smac, mac);
> -                       memcpy(sqp->ud_header.eth.smac_h, smac, ETH_ALEN);
> -               } else {
> -                       /* use the src mac of the tunnel */
> -                       memcpy(sqp->ud_header.eth.smac_h, ah->av.eth.s_mac, ETH_ALEN);
> -               }
>

The last hunk that you removed had a role and was by no means
dead-code, right? so... (1) why it's correct to remove it? (2) if you
want to introduce different way to implement what was done here, why
in this patch? maybe add pre-patch for that
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
