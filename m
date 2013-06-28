From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 13/14] IB/srp: Make transport layer retry count configurable
Date: Fri, 28 Jun 2013 10:28:35 +0200
Message-ID: <51CD4933.5080709@acm.org>
References: <51B87501.4070005@acm.org> <51B8794F.6050003@acm.org> <1372368138.32164.40.camel@frustration.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1372368138.32164.40.camel-zHLflQxYYDO4Hhoo1DtQwJ9G+ZOsUmrO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 06/27/13 23:22, David Dillow wrote:
> On Wed, 2013-06-12 at 15:36 +0200, Bart Van Assche wrote:
>> From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> Allow the InfiniBand RC retry count to be configured by the user
>> as an option in the target login string. The transport layer
>> timeout in nanoseconds is computed as follows from the retry count:
>>
>> rc_timeout = rc_retry_count * 4 * 4096 * (1 << qp->timeout)
>>
>> The default value for tl_retry_count is changed from 7 into 2.
>
> I'm not sure you should change the default, but I've not thought about
> it much.
>
> It should probably also have a default set via module parameter similar
> to the indirect_command_descriptors, etc. Unless srp_daemon is patched,
> this won't be usable without that. I'm not tied to this position, though
> -- we should be moving in the direction of more control via the login
> string.

Hello Dave,

Are you perhaps aware of any IB networks where it is necessary to set 
the RC retry count above 2 ? Anyway, I can prepare an srp_daemon patch 
that makes it easy to configure this parameter if you want.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
