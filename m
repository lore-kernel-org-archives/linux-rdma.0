From: Josh Boyer <jwboyer@gmail.com>
Subject: Re: kernel BUG at drivers/iommu/intel-iommu.c:1767 on F16 3.1.1-2.fc16.x86_64
Date: Tue, 24 Jan 2012 10:00:16 -0500
Message-ID: <CA+5PVA6aE_9+g_UngHeoL3qzPSHL0oX-8N0SbsZpGRdsoXRWsw@mail.gmail.com>
References: <CALfB72BHLmN_vkpz9j7mi4yQWaYfJOojqopJ6d4911vuf3WRAA@mail.gmail.com>
	<CAL1RGDVh7gNTrteiEaGg=4fxW=p3ydZPVf4d1hgtwNT9xUdOMw@mail.gmail.com>
	<CALfB72BUDiZOZY8f4wvYej5Ozur2FZN3h3FNgc78Ur=tUsSCmA@mail.gmail.com>
	<CAL1RGDX9P7tmGTkByEid17FrSFwdAW+4=mb9eUxc_uHvmFOeSg@mail.gmail.com>
	<CALfB72CAwzRe3u2+yQ15+coY9kNgFTZ_Be-b-+aMe6QvbZy-HA@mail.gmail.com>
	<CALfB72CLZMrS+gTR3=0QcGry4vA3wKmgbhjp9Lc06UZtVcxzZg@mail.gmail.com>
	<CALfB72A+A9UDieFtYOMLB9c+XHO8nt8Lr-2pkikaqM=0fJ4OAQ@mail.gmail.com>
	<CAL1RGDVWDsNhHywkmzaGWxZ5ERYatXVh4fGFC_tmOkkLt3Dg+w@mail.gmail.com>
	<CALfB72BqSEKwGdNUnenMjEujKjObhq12jFjmu6VukuA1AtYHrQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALfB72BqSEKwGdNUnenMjEujKjObhq12jFjmu6VukuA1AtYHrQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Albert Strasheim <fullung@gmail.com>
Cc: Roland Dreier <roland@purestorage.com>, linux-rdma@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 20, 2012 at 2:02 PM, Albert Strasheim <fullung@gmail.com> wrote:
> Hello
>
> On Fri, Jan 20, 2012 at 10:23 AM, Roland Dreier <roland@purestorage.com> wrote:
>> On Thu, Jan 19, 2012 at 12:57 AM, Albert Strasheim <fullung@gmail.com> wrote:
>>> Just checking up on this issue. Is there any further testing or
>>> information we can provide to help make a fix happen?
>> I'm not likely to be much help on VT-d issues, but maybe it
>> would be useful to dump all the values in the BUG_ON if its
>> going to trigger, ie just before
>
> Just retested with 3.2.1-1.fc16.x86_64 and the bug seems to be gone.
>
> I confirmed that my test program triggers the bug on 3.1.1-1.fc16.x86_64.
>
> It seems a bunch of IOMMU fixes went in on 9 and 10 January, so it
> seems to have fixed this problem in 3.2.

Possibly not.  Fedora disabled the Intel IOMMU by default in 3.1.6 (ish) and
newer, so if your problem was related to the IOMMU being enabled that might
explain why it went away.

You might try booting with intel_iommu=on and see if it really is gone.

josh
