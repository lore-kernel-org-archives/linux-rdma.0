From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V5 libibverbs 0/7] Completion timestamping
Date: Tue, 7 Jun 2016 14:26:41 +0300
Message-ID: <e3023ed9-4104-74e1-1c82-213195dd83d3@dev.mellanox.co.il>
References: <1464786340-7630-1-git-send-email-yishaih@mellanox.com>
 <1b0ea11b-3762-2335-28dd-eb3ac243104e@redhat.com>
 <20160606233325.GA28769@obsidianresearch.com>
 <bd0b54e6-70ae-27b3-fe1e-8ee729e20479@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <bd0b54e6-70ae-27b3-fe1e-8ee729e20479-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 6/7/2016 5:20 AM, Doug Ledford wrote:
> On 6/6/2016 7:33 PM, Jason Gunthorpe wrote:
>> On Mon, Jun 06, 2016 at 07:02:34PM -0400, Doug Ledford wrote:
>>> On 6/1/2016 9:05 AM, Yishai Hadas wrote:
>>>> Hi Doug,
>>>>
>>>> This V5 series addressed one note that we got for V4,
>>>> details below.
>>>
>>> Thanks, the v5 series was applied.
>>
>> Erm, I sure had a lot of unaddressed comments for this series.
>
> Judging by the way yours and mines conversation went in v4 it seemed you
> were pretty much in favor of it.  If you have specific objections,
> please raise them, we can do incremental fixes.
>
>

The matching libmlx5 series was merged to my public GIT at 
git://openfabrics.org/~yishaih/libmlx5.git.

The merged libmlx5 series addressed few comments on V0 that we found to 
be useful and we confirmed in the list. Will send it shortly inline as well.

Till a formal build, if we'll agree on some API fixes we should do it in 
an incremental way in both libibverbs/libmlx5. After a formal build, the 
API can be extended without any dependency between the libraries by 
using the extended mechanism.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
