From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] opensm: Add support for partition enforcement types
Date: Mon, 11 Jul 2011 08:08:54 -0400
Message-ID: <4E1AE7D6.9060209@dev.mellanox.co.il>
References: <4E135D51.3080208@dev.mellanox.co.il> <20110710112626.GC8520@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110710112626.GC8520-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Alex,

On 7/10/2011 7:26 AM, Alex Netes wrote:
> Hi Hal,
> 
> On 14:52 Tue 05 Jul     , Hal Rosenstock wrote:
>>
>> Partition enforcement types are in, out, and both.
>> Prior to this support, both was being used so that is the default.
>>
>> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
> 
> Now we end up with two parameters for same functionality:
> no_part_enforce - you define whether the enforcement is disabled or enabled.
> part_enforcement_type - you define enforcement type: in/out/both.
> 
> When no_part_enforce is disabled, part_enforcement_type has no meaning.

Yes.

> Don't you find it simpler if we had only one option for partition enforcement
> with 4 options: disabled/in/out/both(default)?

I didn't want to break backward compatibility with existing command line
or option file.

If we were starting from scratch, it would be one option.

-- Hal

> -- Alex
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
