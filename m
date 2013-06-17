From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH 05/14] IB/srp: Maintain a single connection per I_T nexus
Date: Mon, 17 Jun 2013 11:41:59 +0200
Message-ID: <51BED9E7.5070304@profitbricks.com>
References: <51B87501.4070005@acm.org> <51B876BF.4070400@acm.org> <51BA0655.6090707@mellanox.com> <51BA0E8F.3030104@acm.org> <51BA555F.9060807@mellanox.com> <51BAE482.1050304@profitbricks.com> <51BB4DBB.4070800@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51BB4DBB.4070800-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 14.06.2013 19:07, Vu Pham wrote:
[...]
>> For what do you need the same target with multiple pkeys on the same
>> local SRP port?
>>   
> There is no need, it's just a gray area that you can choose to have
> multiple connections to same target using different pkeys (same as dgid)
>> Which other SRP targets exist?
>>   
> 
> Netapp/LSI/Engenio, DDN, TexasMemorySystem Ramsan (IBM), Nimbus, Violin
> Memory, StreamScale
> The last three may be derived from SCST base target.
> 
>> I only know SCST, Solaris COMSTAR and that broken LIO stuff.
>> Does SCST still not support to set the pkey?
>>
>>   
> Yes, I think so
> 
>> Why should we check the dgid?
>>
>>   
> If you want to have multiple connections/qps to same target, but as I
> said above, it's a gray area.
> 
>> Doesn't make any sense to me to connect both target ports to the same
>> local port. 
> What if a target always expose single consistent and unique SRP port
> with tuple <id_ext, ioc_guid>, the ioc_guid part is not derived from any
> of its local HCA's GUID, then you can connect to this target thru
> different HCA ports (different dgid) as different paths to same target.
>
Do you have an example for a target which does it like this or a use
case where this makes sense?

I guess you're proposing here to use a driver global list of target
connections instead of handling this per local SRP port. This would
result in bigger changes which I wouldn't do without a good reason.

>> If you do so, the multipath-tools will crash. Note: This
>> function is called per local SRP port. Perhaps, a note should be added
>> to that function that it only has to be called per local SRP port.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
