From: Michael Di Domenico <mdidomenico4-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: non-symmetric MFT
Date: Thu, 18 Jul 2013 13:50:52 -0400
Message-ID: <CABOsP2O8s7nrACmWOj5FHCVUemc-XJP2pLyN5Fk_zLRJx6byzg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

i;ve run ibdiagnet -r on my infiniband network, i have a few errors
showing up with this

Found a non symmetric MFT on MLID:0x0CBB got to node:<guid> through
port:17 which does not point back to node, etc etc...

what does this mean?  i tried to look at the source but the comment a
few lines above is not clear english, so i'm not sure what this is
trying to tell me

my fabric is up, so i'm assuming this is a routing issue, but i'm not sure how
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
