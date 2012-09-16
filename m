From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 2/6] opensm: Make it possible to enable opensm with chkconfig
Date: Sun, 16 Sep 2012 11:55:16 +0200
Message-ID: <5055A204.2030607@acm.org>
References: <505077FF.6060408@acm.org> <20120916091008.GA8243@calypso>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120916091008.GA8243@calypso>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 09/16/12 11:10, Alex Netes wrote:
> Hi Bart,
>
> On 13:54 Wed 12 Sep     , Bart Van Assche wrote:
>> The command "chkconfig $service on" enables a service in the "Default-Start"
>> runlevels.
>>
>> Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
>> ---
>>   scripts/opensm.init.in |    4 ++--
>>   1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/scripts/opensm.init.in b/scripts/opensm.init.in
>> index 0c84bd3..9ec08a2 100644
>> --- a/scripts/opensm.init.in
>> +++ b/scripts/opensm.init.in
>> @@ -9,8 +9,8 @@
>>   # Provides: opensm
>>   # Required-Start: $syslog
>>   # Required-Stop:
>> -# Default-Start: none
>> -# Default-Stop: 0 1 6
>> +# Default-Start: 2 3 5
>> +# Default-Stop: 0 1 4 6
>
> Why it's needed also to stop on runlevel 4?

Good question. As far as I know runlevel 4 is not used. I've noticed 
though that some Linux distributions (RHEL) enable services in runlevel 
4 that are also enabled in runlevel 3. The LSB isn't very clear about 
this subject though. A quote from 
http://refspecs.linux-foundation.org/LSB_3.2.0/LSB-Core-generic/LSB-Core-generic/runlevels.html:

0	halt
1	single user mode
2	multiuser with no network services exported
3	normal/full multiuser
4	reserved for local use, default is normal/full multiuser
5	multiuser with a display manager or equivalent
6	reboot

If I interpret the above correctly, enabling opensm in runlevel 4 should 
be fine on all Linux distributions ?

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
