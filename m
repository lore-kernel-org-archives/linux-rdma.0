From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [GIT PULL] Please pull RDMA subsystem changes
Date: Thu, 1 Feb 2018 13:33:09 -0700
Message-ID: <20180201203309.GO23352@mellanox.com>
References: <20180131174735.GA18568@ziepe.ca>
 <CA+55aFxmnW-iu1Na3QC8Ci8Q_Qdfn2Ak_9wDB6+A564R=Xn9Ag@mail.gmail.com>
 <20180131210457.GE23352@mellanox.com>
 <CA+55aFxySLoCHcmZgx2PiF6jEazVOSy=2idccRsWqOzmyK2gaw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFxySLoCHcmZgx2PiF6jEazVOSy=2idccRsWqOzmyK2gaw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 01, 2018 at 11:12:43AM -0800, Linus Torvalds wrote:

> For pure testing of temporary kernels that aren't actually in any way
> upstream anyway, is there any reason why you can't just have a
> separate kernel with the merges in place, but not make them part of
> your development tree?

Okay, thanks, I appreciate the clarity here.

We can work something like this into our process, a temporary throw
away branch is certainly easy enough to create.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
