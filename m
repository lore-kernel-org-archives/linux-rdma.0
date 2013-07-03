From: Jeff Becker <jeffrey.c.becker-NSQ8wuThN14@public.gmane.org>
Subject: Re: PATCH: opensm enhancements
Date: Wed, 3 Jul 2013 09:20:40 -0700
Message-ID: <51D44F58.1080903@nasa.gov>
References: <51CB5BF1.1090601@nasa.gov> <51D3FBA7.9040604@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51D3FBA7.9040604-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Ciotti, Robert B. (ARC-TNE)" <bob.ciotti-NSQ8wuThN14@public.gmane.org>, "Talcott, Dale R. (ARC-TN)[Computer Sciences Corporation]" <dale.r.talcott-1-NSQ8wuThN14@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Hal,

I have some testing info about the second patch below.

On 07/03/2013 03:23 AM, Hal Rosenstock wrote:
> HI Jeff,
>
> On 6/26/2013 5:24 PM, Jeff Becker wrote:
>> Hi Hal. At the OFA workshop, I mentioned that I've been working on some
>> modifications to opensm that we use at NASA. Following extensive testing
>> of these applied to opensm 3.3.13 (the version we run here), I have
>> ported these to top of tree opensm, and have tested them on a small
>> cluster.
> Thanks for getting this done! For future reference, patches should be
> sent as plain text as this makes it easier to comment.

OK. So I just send the output of git-format-patch directly? It appears 
to be formatted properly.
>
>> The first patch modifies the console logflush command to take "on" or
>> "off" as an argument for toggling.
> Thanks. Applied.
>
>> The second (more extensive) patch
>> adds a command line option to specify a file in which each line contains
>> a switch GUID/port pair to be ignored by opensm. The idea is to specify
>> this file when you start opensm (it can be empty), and add ports to
>> ignore (one per line for each end of a connection) to the file. At the
>> next heavy sweep (or HUP) the sm will reprogram the forwarding tables
>> without including the ignored links. We use this for replacing cables,
>> as well as for system expansion (adding new racks).
> I'll comment on this one later.

Dale (cc'd) did some testing with my patch on Pleiades in preparation 
for a system augmentation (new racks) happening soon. He found that the 
SM correctly produces routes that do not use links marked to be ignored, 
but when you then remove or disable the links, the SM re-routes the 
fabric anyway and comes up with different routes than before. This 
rerouting causes problems with existing connections. There also appears 
to be a bookkeeping problem such that some of these links get added to 
the SM's "light sampling" list and never get removed. This ties up 
outstanding MAD packet slots, causing the SM to become unresponsive for 
several seconds every time it reviews its light sampling list.

I'm working on fixing these. I'll take care of the second problem 
(incorrectly getting added to the light sampling list) first. Is it 
possible this problem is related to the re-routing on port disable 
problem? Anyhow, if you have any specific comments about these issues, 
that would be great. Thanks, and have a great Fourth of July.

-jeff
>
> -- Hal
>
>> Please let me know if you have any questions/issues with these. Thanks.
>>
>> -jeff

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
