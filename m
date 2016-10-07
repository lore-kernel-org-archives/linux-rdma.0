From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 0/5 for rdma-core] Five rxe_cfg patches
Date: Fri, 7 Oct 2016 13:51:59 -0700
Message-ID: <c1901fd9-3620-50ec-0db3-9b271fd1e90b@sandisk.com>
References: <bf5dba39-7e14-23ee-4aa1-2a276d629fe9@sandisk.com>
 <20161007190224.GB27537@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161007190224.GB27537-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/07/2016 12:02 PM, Jason Gunthorpe wrote:
> On Fri, Oct 07, 2016 at 11:37:43AM -0700, Bart Van Assche wrote:
>> Hello Doug, Jason and Moni,
>>
>> These five patches is what I came up with after having had a look at the
>> rxe_cfg source code. It would be appreciated if these patches would be
>> considered for inclusion in the rdma-core repository. The filenames of these
>> patches are:
>
> Thanks Bart, it would be best in Moni looks at these when he returns,
> but nothing seemed off to my uneducated eye.
>
> While you are looking at this could you also look at the use of
> /var/rxe in that script?
>
> That is not a FHS path, so it needs to be something else, and the
> script should probably pass through substitution to pick up the right
> path, whatever that is.. Based on the name sounds like /var/cache or
> /var/lib ?

Hello Jason,

Do you think the names of the network interfaces to which the rdma_rxe 
driver should bind should be stored in a separate file? To me this looks 
like a suboptimal approach. Shouldn't we drop the /var/rxe/rxe file 
completely and add a new boolean to the files in which other network 
interface parameters are already stored, e.g. 
/etc/NetworkManager/system-connections/* ?

Thanks,

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
