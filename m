From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Status of RXE/Soft-RoCE driver?
Date: Mon, 2 May 2016 18:51:50 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB04823F@ORSMSX109.amr.corp.intel.com>
References: <5721F149.1090004@grimberg.me> <20160428115653.GB21343@leon.nu>
 <CAJ3xEMjz-VLvaRvVFBtNc+9GDppW6qjw_5KwZvPRDi1RdUnsgQ@mail.gmail.com>
 <5722C24B.6020108@redhat.com> <20160429051755.GC774@leon.nu>
 <a1d504ff-716c-210a-7114-517577d2e0fa@redhat.com>
 <20160429205434.GA11286@obsidianresearch.com>
 <20160430072847.GB25593@leon.nu> <572725E0.4090303@dev.mellanox.co.il>
 <20160502175709.GA31976@obsidianresearch.com>
 <20160502183151.GA6462@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160502183151.GA6462-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Tzahi Oved (tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org)" <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > The other take away from the Collab discussion is that there is a
> > reasonable opinion that linux-rdma is not the right forum to decide if
> > major changes to the multi-vendor common-verbs APIs are
> > OK. I don't know if we reached a consensus on this or not.
> 
> Who had that discussion, and why do you believe it's viable?  In fact
> I'd like to state that any other forum than linux-rdma simply is not
> credible, just like the relevant list is the only credible place to
> discuss the ABIs for any other Linux subsystem.

The problem is that the linux-rdma stack tries to expose vendor-specific, transport-specific, hardware-implementation specific features to user space under the guise of being a common API.  And many of the items being exported are not defined by any standards body.  Guidance about what's sane needs to come from somewhere other than vendor X posted a patch to change the common API because it suits the latest model of their HW.

No one is suggesting that the linux-rdma developers do not own the ABI or kernel components, or that some external entity (like OFA) has any authority to dictate what needs to be done.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
