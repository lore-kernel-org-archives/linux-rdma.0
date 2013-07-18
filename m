From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: non-symmetric MFT
Date: Thu, 18 Jul 2013 17:18:07 -0400
Message-ID: <51E85B8F.7010109@dev.mellanox.co.il>
References: <CABOsP2O8s7nrACmWOj5FHCVUemc-XJP2pLyN5Fk_zLRJx6byzg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CABOsP2O8s7nrACmWOj5FHCVUemc-XJP2pLyN5Fk_zLRJx6byzg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Di Domenico <mdidomenico4-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/18/2013 1:50 PM, Michael Di Domenico wrote:
> i;ve run ibdiagnet -r on my infiniband network, i have a few errors
> showing up with this
> 
> Found a non symmetric MFT on MLID:0x0CBB 

Is that the real MLID or a typo ? MLIDs start at 0xC000.

> got to node:<guid> through
> port:17 which does not point back to node, etc etc...
> 
> what does this mean?

It means that for some MLID on current switch, there is a port mask bit
set to go to a neighbor switch but when looking at same MLID in MFT on
neighbor switch, there isn't a port mask bit set pointing back to this
switch.

> i tried to look at the source but the comment a
> few lines above is not clear english, so i'm not sure what this is
> trying to tell me
> 
> my fabric is up, 

Does IPoIB have full connectivity ?

> so i'm assuming this is a routing issue, 

It could be a multicast routing issue or tool issue.

-- Hal

> but i'm not sure how
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
