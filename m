From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 3/4 for opensm] /etc/init.d/opensmd: Improve systemd integration
Date: Wed, 24 Oct 2012 16:45:51 +0200
Message-ID: <5087FF1F.20907@acm.org>
References: <505C7D44.9060500@acm.org> <20121024132726.GB18591@calypso> <5087FC29.4030303@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5087FC29.4030303-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/24/12 16:33, Doug Ledford wrote:
> On 10/24/2012 9:27 AM, Alex Netes wrote:
>> On 16:44 Fri 21 Sep     , Bart Van Assche wrote:
>>>   start () {
>>> +    if [ -e $pidfile ]; then
>>
>> On opensm segfault (happens one in a while :), pidfile won't be removed, so
>> you won't be able to start the opensm again. I guess that same thing can
>> happen on warm reboot.
>
> The stop action in the script should handle cleanup for you.  If it's
> called, and a pid file exists, but the pid is not running, it should
> remove the pid file and the subsystem lock file so that a clean start works.

Hello Doug,

Do we really need the lock file ? On some Linux systems (Ubuntu) the 
/var/lock/subsys directory does not even exist.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
