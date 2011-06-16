From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags: saquery; reuse
 dump_one_mcmember_record function
Date: Thu, 16 Jun 2011 14:46:36 -0700
Message-ID: <20110616144636.4d2483fb.weiny2@llnl.gov>
References: <20110616111024.fde795bc.weiny2@llnl.gov>
	<4DFA6D60.9070609@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DFA6D60.9070609-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 16 Jun 2011 13:53:52 -0700
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> On 6/16/2011 2:10 PM, Ira Weiny wrote:
> > -		printf("MCMemberRecord member dump:\n"
> > -		       "\t\tMGID....................%s\n"
> > -		       "\t\tMlid....................0x%X\n"
> > -		       "\t\tPortGid.................%s\n"
> > -		       "\t\tScopeState..............0x%X\n"
> > -		       "\t\tProxyJoin...............0x%X\n"
> > -		       "\t\tNodeDescription.........%s\n",
> > -		       inet_ntop(AF_INET6, p_mcmr->mgid.raw, gid_str,
> > -				 sizeof gid_str),
> > -		       cl_ntoh16(p_mcmr->mlid),
> > -		       inet_ntop(AF_INET6, p_mcmr->port_gid.raw,
> > -				 gid_str2, sizeof gid_str2),
> > -		       p_mcmr->scope_state, p_mcmr->proxy_join, node_name);
> > +		dump_one_mcmember_record(data);
> 
> This will print more info per MC member with much of it (group related)
> repeated. Is there some need for the additional info or is this just for
> code reuse ?

"need"; I guess not.  But I thought it was odd that the information was different for the 2 query methods.  There is nothing in the documentation or help output which indicates the output would be different.

That said I do see what you mean regarding the amount of data returned.  I figured most users were probably grepping this output anyway, as on a large fabric both methods return a sizable amount of data.

> If it's the latter, I would prefer to not see it change or
> add an additional parameter to dump_one_mcmember_record as to the
> specific fields to print.

Yea, the most useful output of "-m" is when used with the optional MLID value.

Ok, For now I will reject the patch.  ;-)

Ira

> 
> -- Hal
> 
> > +		printf("\t\tNodeDescription.........%s\n", node_nam
> 


-- 
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
