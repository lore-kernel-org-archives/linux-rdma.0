From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core] libibumad: clean up htonll/ntohnll handling
Date: Mon, 22 May 2017 11:31:23 -0400
Message-ID: <567bd675-a952-e593-70d0-6e7a5ef50e5d@dev.mellanox.co.il>
References: <20170522141722.50502-1-jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170522141722.50502-1-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 5/22/2017 10:17 AM, Jarod Wilson wrote:
> Only ntohll was being checked to see if it wasn't defined, and was then
> redefining htonll as well as ntohll. This was causing some problems for
> the compile of the opa-ff package. Simple enough to rearrange this code a
> bit such that htonll and ntohll are handled entirely independent of one
> another.

It used to be the case that they were treated independently.

> Reported-by: Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Reviewed-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
