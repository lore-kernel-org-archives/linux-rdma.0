From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: Change To max_cm_mtu when changing mode to connected
Date: Tue, 9 Jun 2015 09:06:47 +0300
Message-ID: <CAAk-MO_=-C2JqoTsHFoVZZSHP5YU2g7AMwkQc6Vup3Ubf5Pv=A@mail.gmail.com>
References: <1433673371-5355-1-git-send-email-erezsh@mellanox.com>
	<20150608164224.GA2499@obsidianresearch.com>
	<1433797482.90034.2.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433797482.90034.2.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ELi Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 9, 2015 at 12:04 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Mon, 2015-06-08 at 10:42 -0600, Jason Gunthorpe wrote:
>> On Sun, Jun 07, 2015 at 01:36:11PM +0300, Erez Shitrit wrote:
>> >
>> > When switching between modes (datagram / connected) change the MTU
>> > accordingly.
>> > datagram mode up to 4K, connected mode up to (64K - 0x10).
>>
>> Is this a bug fix (describe the user visible impact)? Should it go to
>> -stable? Add a Fixes: line?
>
> I'm not sure I would call it a bug.  Setting the MTU to max
> automatically is a policy decision more than anything else.  Currently,
> you have to enable connected mode, then set the MTU.  Both initscripts
> and NetworkManager do this for you on Red Hat, so the user sees no
> difference here.  I can't speak to other OSes.  I'm OK with setting

The only real reason for a user to switch to CM mode is for the
performance he can get, and this is only by the huge MTU the CM gives,
so it somehow should be part of the "mode setting".
As you said RH does it (in the new versions of its OS's only) via
scripting outside of the driver code, other vendor doesn't.

> connected mode MTU to max by default once we get the scatter/gather
> support for IPoIB added.

OK, great. Thanks.

> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>               GPG KeyID: 0E572FDD
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
