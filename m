From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [ANNOUNCE] Open Fabrics Verbs Working Group (OFVWG) meeting
 tomorrow - 9/13/2016 at 11:00PDT
Date: Wed, 14 Sep 2016 22:39:26 -0700
Message-ID: <20160915053926.GA16098@infradead.org>
References: <VI1PR0501MB2189FBF50563679C4E61B1EFB1FF0@VI1PR0501MB2189.eurprd05.prod.outlook.com>
 <CAG53R5XUDkVgu5R2wHOyxd0FGEuEU+CTf1H_d9=Mk+DnDS51Ug@mail.gmail.com>
 <20160913064857.GA5988@infradead.org>
 <CAG53R5UO50zXYF_oUUA_MUhx+xYS8FbDkTsAzon6Fn4syDyWvQ@mail.gmail.com>
 <20160913070418.GA31616@infradead.org>
 <20160913103238.GW8812@leon.nu>
 <20160914123059.GA868@infradead.org>
 <20160914171349.GG16014@obsidianresearch.com>
 <20160915050005.GF26069@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160915050005.GF26069-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 15, 2016 at 08:00:05AM +0300, Leon Romanovsky wrote:
> Do you see any desire of HFI authors to move to new general user API?

A general API requires something general to be implemented first.
That's usually been the problem with driver specific APIs..

Once in a while people try to implement generic concepts drivers
specific, in which case it's easy to redirect them to a generic
subsystem.  It's been a while since I look at HFI, but IIRC only
the eeprom bits feel into such an existing categeory.  In theory
anything PSM specific could fit into a PSM subsystem, but without
anyone else even looking into that it's hard to define a subsystem
for it.  And there's just lots of weird stuff which we'd either
need to reject entirely (too late for HFI now) or live with a driver
specific API.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
