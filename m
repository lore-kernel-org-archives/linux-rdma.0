From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [ewg] [PATCHv8 02/11] ib_core: IBoE support only QP1
Date: Sun, 16 May 2010 08:17:10 +0300
Message-ID: <4BEF7FD6.8070206@voltaire.com>
References: <20100218172344.GC12286@mtls03>	<ada1vdqaqpc.fsf@roland-alpha.cisco.com> <20100506142849.GC29792@mtldesk030.lab.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100506142849.GC29792-8YAHvHwT2UEvbXDkjdHOrw/a8Rv0c6iv@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Eli Cohen wrote:
> Roland Dreier wrote:
>   
>>  > @@ -1007,7 +1010,7 @@ static void ib_sa_add_one(struct ib_device *device)
>>  > -	sa_dev = kmalloc(sizeof *sa_dev +
>>  > +	sa_dev = kzalloc(sizeof *sa_dev +
>>
>> Do you happen to remember why you needed these kmalloc -> kzalloc conversions?
>>     
> I can't remember why. I do have this habbit of prefering kzalloc over kmalloc because it saves troubles sometimes.
>   
Hi Eli, just a friendly comment, best if such cleanup is done in a 
separate patch, else later someone attempting to debug/bisect (who might 
be yourself btw) could spend a hell of time wondering why it was done 
here and in the framework of this patch...

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
