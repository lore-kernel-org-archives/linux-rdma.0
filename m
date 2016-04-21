From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: Testing for RDMA with ib_srp: Failed to map data (-12) with
 max_sectors_kb=4096 and buffered I/O with 4MB writes
Date: Thu, 21 Apr 2016 21:15:01 +0300
Message-ID: <571918A5.8050504@grimberg.me>
References: <559411025.30902774.1461207472544.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <559411025.30902774.1461207472544.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> Hello
>
> I am still on my quest for getting 4MB buffered writes to be stable to RDMA SRP targets.
> Lots of testing has been performed here with EDR 100 back to back connections using
> mellanox ConnectX-4 with mlx5_ib, an dthe ib_srp* drivers on target server and client.
>
> In summary:
>   setting max_sectors_kb=4096 and running DIRECT_IO is solid as a rock
>   setting max_sectors_kb=2048 and running buffered 4MB writes to an FS on a multipath is rock solid
>
>   However:
>   setting max_sectors_kb=4096 and running buffered I/O sees serious mapping issues.
>
>
> I have isolated the failure and call flow to this
>
> srp_queuecommand
>      srp_map_data(scmnd, ch, req);
> 	  srp_map_idb
> 	      ret = srp_map_finish_fr(&state, req, ch, 1);	
>
>
> The -12 is returned by srp_map_finish_fr() and fed back to fail with
> ib_srp: Failed to map data (-12)

Can you print out how many FRs we used at this point?

state->nmdesc?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
