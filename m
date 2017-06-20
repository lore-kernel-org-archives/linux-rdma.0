From: bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org (J. Bruce Fields)
Subject: Re: [PATCH v2 19/19] sunrpc: Disable splice for krb5i
Date: Tue, 20 Jun 2017 15:41:45 -0400
Message-ID: <20170620194145.GD13008@fieldses.org>
References: <20170616151535.14210.34926.stgit@klimt.1015granger.net>
 <20170616152254.14210.48071.stgit@klimt.1015granger.net>
 <1497693712.4684.4.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1497693712.4684.4.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, Jun 17, 2017 at 06:01:52AM -0400, Jeff Layton wrote:
> This seems like the right thing to do, IMO. It's nice to avoid copies
> where we can, but this is just one of the places where we can't, at
> least with the way things stand now. It is a pity we don't have a way to
> CoW these things though.

We have to run all the data through CPU anyway for the checksum, so I
guess what I was thinking we could do--if we decided we needed the
optimization--was to figure out how to copy and checksum (or encrypt)
simultaneously in one pass.

--b.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
