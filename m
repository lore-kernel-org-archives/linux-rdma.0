From: Saeed Mahameed <saeedm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: net/mlx5: E-Switch, Add SR-IOV (FDB) support
Date: Thu, 10 Dec 2015 16:45:53 +0200
Message-ID: <CALzJLG-gWbpngRw4LLp=NEjm4KhaectZUybSsbUpVDE_A4uWJA@mail.gmail.com>
References: <20151210103509.GA9143@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151210103509.GA9143@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 10, 2015 at 12:35 PM, Dan Carpenter
<dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> Hello Saeed Mahameed,
>
> The patch 81848731ff40: "net/mlx5: E-Switch, Add SR-IOV (FDB)
> support" from Dec 1, 2015, leads to the following static checker
> warning:
>
>         drivers/net/ethernet/mellanox/mlx5/core/eswitch.c:579 esw_fdb_set_vport_rule()
>         warn: passing zero to 'PTR_ERR'
>
> drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
>    568          esw_debug(esw->dev,
>    569                    "\tFDB add rule dmac_v(%pM) dmac_c(%pM) -> vport(%d)\n",
>    570                    dmac_v, dmac_c, vport);
>    571          flow_rule =
>    572                  mlx5_add_flow_rule(esw,
>    573                                     match_header,
>    574                                     match_c,
>    575                                     match_v,
>    576                                     MLX5_FLOW_CONTEXT_ACTION_FWD_DEST,
>    577                                     0, &dest);
>    578          if (IS_ERR_OR_NULL(flow_rule)) {
>
> mlx5_add_flow_rule() only returns NULL on error.  It never returns
> ERR_PTRs.
>
>    579                  pr_warn(
>    580                          "FDB: Failed to add flow rule: dmac_v(%pM) dmac_c(%pM) -> vport(%d), err(%ld)\n",
>                                                                                                      ^^^^^^^^
> It's not a terrible bug but this always says "err(0)" which is not very
> useful, and it causes this static checker warning.
Hi Dan,

Thanks for pointing this out, this is already fixed in the latest flow
steering patches sent to net-next.
"net/mlx5: Use flow steering infrastructure for mlx5_en"

>
>    581                           dmac_v, dmac_c, vport, PTR_ERR(flow_rule));
>    582                  flow_rule = NULL;
>    583          }
>    584  out:
>    585          kfree(match_v);
>    586          kfree(match_c);
>    587          return flow_rule;
>    588  }
>
> regards,
> dan carpenter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
