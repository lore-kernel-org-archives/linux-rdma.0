From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: fprintf stderr in libibverbs
Date: Wed, 28 Oct 2009 10:51:22 -0700
Message-ID: <adazl7bs8yt.fsf@cisco.com>
References: <20091028054232.GA1966@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091028054232.GA1966-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> (Jason Gunthorpe's
	message of "Tue, 27 Oct 2009 23:42:32 -0600")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > My main goal would be to remove prints from the library in common
 > cases like no IB drivers loaded, no devices present, or no
 > permissions. I have an app where the prints are inconvient.
 > 
 > What I was thinking was to return these cases via errno (ENOSYS,
 > ENODEV, EPERM) in ibv_get_device_list. Do you think that is OK?

Yes, that makes sense I guess.

 > int ibv_get_device_list_ex(struct ibv_device ***devices,int *num_devices, 
 >                            const char **warning_msg);

Are there that many cases where the output is important enough and
likely enough that it's worth a new API to get it out when stderr
doesn't suffice?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
