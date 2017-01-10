From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core] redhat: Remove non-existed infiniband modules
Date: Mon, 9 Jan 2017 22:22:19 -0500
Message-ID: <ce40642e-5309-3c79-890b-e0c73998a6be@redhat.com>
References: <20170109085429.32598-1-leonro@mellanox.com>
 <20170109154302.GC29687@obsidianresearch.com>
 <20170109174025.GB7218@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170109174025.GB7218-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2017-01-09 12:40 PM, Leon Romanovsky wrote:
> On Mon, Jan 09, 2017 at 08:43:02AM -0700, Jason Gunthorpe wrote:
>> On Mon, Jan 09, 2017 at 10:54:29AM +0200, Leon Romanovsky wrote:
>>> The modules ib_addr.ko, ib_mad.ko and ib_sa.ko were integrated
>>> into ib_core.ko in following kernel commits:
>>>  * c2e49c92326f ("IB/SA: Integrate ib_sa module into ib_core module")
>>>  * 4c2cb4220431 ("IB/MAD: Integrate ib_mad module into ib_core module")
>>>  * e3f20f02864f ("IB/core: Integrate IB address resolution module into core")
>>>
>>> Fixes: 39fa824dd80e ("redhat: add udev/systemd/etc infrastructure bits")
>>> Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>  redhat/rdma.kernel-init | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> Make sense to me, but if we are saying the redhat scripts only work
>> with a certain newish kernel then it would be great to also purge all
>> that crufty compat stuff (mttrs, pci tuning, etc) so we can better
>> understand what is still actually needed..
>
> Other stuff doesn't crash our verification runs of upstream rdma-core
> vs. upstream kernel :)
>
> In our previous discussions, we agreed to have master branch to be in
> sync with Linus's tree and proposed to distributions to manage special
> (backported) branches for specific releases.
>
> And I agree with you and  would like to see compat stuff removed.
>
> Doug, Jarod
> What do you think? Can you do it?

I think this should be fine, I don't think rdma-core is going to make 
it's way (at least not directly) back to distros with sufficiently old 
enough rdma kernel stacks that this would cause any issues.

-- 
Jarod Wilson
jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
