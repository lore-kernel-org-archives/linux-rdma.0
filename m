From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags: saquery; reuse dump_one_mcmember_record
 function
Date: Thu, 16 Jun 2011 16:53:52 -0400
Message-ID: <4DFA6D60.9070609@dev.mellanox.co.il>
References: <20110616111024.fde795bc.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110616111024.fde795bc.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/16/2011 2:10 PM, Ira Weiny wrote:
> -		printf("MCMemberRecord member dump:\n"
> -		       "\t\tMGID....................%s\n"
> -		       "\t\tMlid....................0x%X\n"
> -		       "\t\tPortGid.................%s\n"
> -		       "\t\tScopeState..............0x%X\n"
> -		       "\t\tProxyJoin...............0x%X\n"
> -		       "\t\tNodeDescription.........%s\n",
> -		       inet_ntop(AF_INET6, p_mcmr->mgid.raw, gid_str,
> -				 sizeof gid_str),
> -		       cl_ntoh16(p_mcmr->mlid),
> -		       inet_ntop(AF_INET6, p_mcmr->port_gid.raw,
> -				 gid_str2, sizeof gid_str2),
> -		       p_mcmr->scope_state, p_mcmr->proxy_join, node_name);
> +		dump_one_mcmember_record(data);

This will print more info per MC member with much of it (group related)
repeated. Is there some need for the additional info or is this just for
code reuse ? If it's the latter, I would prefer to not see it change or
add an additional parameter to dump_one_mcmember_record as to the
specific fields to print.

-- Hal

> +		printf("\t\tNodeDescription.........%s\n", node_nam

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
