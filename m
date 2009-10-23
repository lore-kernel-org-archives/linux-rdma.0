From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [ofa-general] [PATCH -- repost] infiniband-diags: Fix IB
 network discovery from switch node.
Date: Fri, 23 Oct 2009 05:14:25 +0200
Message-ID: <20091023031425.GM20210@me>
References: <4A9548AA.4020900@gmail.com>
 <20090923172451.fb20ab9b.weiny2@llnl.gov>
 <4AC232D5.2060806@gmail.com>
 <20090929164842.c1ab7d06.weiny2@llnl.gov>
 <20091007103525.8982fc2f.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091007103525.8982fc2f.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Julia Volynsky <juliav-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Ira,

On 10:35 Wed 07 Oct     , Ira Weiny wrote:
> 
> Perhaps you missed this patch the first time around.

Right, I missed this masked inside this email message.

And yes, it would be better to send a patches as separate emails. And of
course you can still use In-Replay-To: email header line to keep a
discussion thread.

> Eli, verified that it worked for him on the switch as well as works for me.  This applies to current master as is.
> 
> Eli, I added you as signing off on this.
> 
> Thanks guys,
> Ira
> 
> From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> Date: Tue, 22 Sep 2009 11:08:28 -0700
> Subject: [PATCH] infiniband-diags/libibnetdisc/src/ibnetdisc.c: fix bug in single node processing.
> 
> 	Eli fixed an issue with running ibnetdiscover from a switch but it
> 	introduced a bug in processing a single switch:
> 
> 17:19:42 > ./iblinkinfo -S 0x000b8cffff00490c
> Switch 0x000b8cffff00490c MT47396 Infiniscale-III Mellanox Technologies:
> ...
>            8   11[  ] ==( 4X 2.5 Gbps   Down/ Polling)==>             [  ] "" ( )
>            8   12[  ] ==( 4X 5.0 Gbps Active/  LinkUp)==>             [  ] "" ( )
>            8   13[  ] ==( 4X 2.5 Gbps   Down/ Polling)==>             [  ] "" ( )
> ...
> 
> 	The port we "come in on" when discovering the switch is not reported properly.
> 
> 	This patch reverses Eli's patch and fixes his original bug in a way
> 	which does not introduce the above issue.
> 
> Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> Signed-off-by: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Applied. Thanks.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
