From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core v3] redhat/spec: further cleanups to
 depdendencies, descriptions, formatting
Date: Mon, 9 Jan 2017 22:20:18 -0500
Message-ID: <05b2421e-083d-319e-7146-45982d31a2bf@redhat.com>
References: <20161222181404.57469-1-jarod@redhat.com>
 <20170109213910.31871-1-jarod@redhat.com>
 <20170109223631.GB10850@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170109223631.GB10850-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2017-01-09 5:36 PM, Jason Gunthorpe wrote:
> On Mon, Jan 09, 2017 at 04:39:10PM -0500, Jarod Wilson wrote:
>> These are numerous additional little fixups for the Fedora/Red Hat spec
>> file, stemming from Fedora package review.
>>
>> - Per https://fedoraproject.org/wiki/Packaging:Systemd it seems we need to
>>   have systemd as a BuildRequires for %{_unitdir} to evaluate properly.
>>
>> - Add explicit dependencies on kmod, and systemd, because in the world of
>>   containers and some virt guests, these aren't automatically pulled in,
>>   due to not having a kernel installed in the container or guest.
>>
>> - Add missing Requires to rdma-core-devel on each sub-package it provides
>>   devel headers and libs for
>>
>> - Update summary of libibverbs to mention RoCE too
>>
>> - Add requirement on logrotate to srp_daemon
>
> I thought we agreed to just dump the rsyslog stuff?
>
> From 304bbeadf79efe01e8db8230e21d812e1fec152f Mon Sep 17 00:00:00 2001
> From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Date: Mon, 9 Jan 2017 15:34:44 -0700
> Subject: [PATCH] srp: Do no include example log rsyslog configuration
>
> Distros are now using systemd so 'journalctl -u srp_daemon' does
> the same thing.
>
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Ah, yes. Whoops. I blame vacation, I forgot about that when trying to 
get back up to speed on this today. :)

-- 
Jarod Wilson
jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
