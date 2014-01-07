From: "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 2/9] IB/usnic: Fix format not a string literal
 warnings
Date: Tue, 7 Jan 2014 22:03:06 +0000
Message-ID: <4A9AC423-DAC6-4F3A-B552-4081D2C50EF5@cisco.com>
References: <1387298917-7365-1-git-send-email-umalhi@cisco.com>
 <1387298917-7365-3-git-send-email-umalhi@cisco.com>
 <52B56634.1020300@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52B56634.1020300-HInyCGIudOg@public.gmane.org>
Content-Language: en-US
Content-ID: <7DBB7705731FF64F9C070EAD1F0A299E-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "<linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Bart,
	This has been fixed in the latest patchset:
http://www.spinics.net/lists/linux-rdma/msg18170.html
http://www.spinics.net/lists/linux-rdma/msg18171.html

Upinder

On Dec 21, 2013, at 1:58 AM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:

> On 12/17/13 17:48, Upinder Malhi wrote:
>> Few printks in usnic are called w/o a string literal.
>> Intel GCC is throwing warnings and this patch provides a fix
>> for these.
>> 
>> [ ... ]
>> @@ -372,8 +372,7 @@ static void usnic_ib_undiscover_pf(struct kref *kref)
>> 		}
>> 	}
>> 
>> -	if (!found)
>> -		WARN("Failed to remove PF %s\n", pci_name(dev));
>> +	WARN(found, "Failed to remove PF %s\n", pci_name(dev));
>> 
>> 	mutex_unlock(&usnic_ib_ibdev_list_lock);
>> }
> 
> The old code printed a warning if found == 0. The new code prints a
> warning if found != 0. If this is on purpose I think this change should
> be in a separate patch.
> 
> Bart.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
