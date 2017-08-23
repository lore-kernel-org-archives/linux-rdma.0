From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core] mlx5: Return pointer to CQ doorbell
Date: Wed, 23 Aug 2017 15:13:38 +0300
Message-ID: <1b7e41dc-4873-7c0a-6cdb-bc499af70af2@dev.mellanox.co.il>
References: <1502976998-20906-1-git-send-email-yishaih@mellanox.com>
 <20170817173320.GB22792@obsidianresearch.com>
 <20170817173932.GJ23648@mtr-leonro.local>
 <20170817180349.GD24735@obsidianresearch.com>
 <99bc8f57-6a58-d309-7142-74cc498f7feb@dev.mellanox.co.il>
 <20170821152237.GA3400@obsidianresearch.com>
 <912a3e5b-7dbc-061a-53f5-b3cf3bce9d9e@dev.mellanox.co.il>
 <20170822163007.GB4922@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170822163007.GB4922-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 8/22/2017 7:30 PM, Jason Gunthorpe wrote:
> On Tue, Aug 22, 2017 at 11:36:42AM +0300, Yishai Hadas wrote:
>> On 8/21/2017 6:22 PM, Jason Gunthorpe wrote:
>>> Is there existing code out there that uses cq_out->uar and works
>>> properly today? Yes or No?
>>
>> No, only this fix enables that to work properly.

> Particularly since a patch to do this with proper compatibility
> exists, and there is no reason at all to take a shortcut.
>

We are not looking for a shortcut but for a solution that will match 
majority users if not all.

Changing the symbol version for this API will cause that applications 
that will be linked against this version won't be able to run at all on 
previous RH packages (e.g RH 7.3/7.4) even if this flow wasn't used at 
all as we expect. As pointed, from our knowledge there are no customers 
for that specific *rare* flow in mlx5 DV and we prefer to stay with 
current bug fix and same API version.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
