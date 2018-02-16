From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core] vmw_pvrdma: Fix SRQN returned to library
Date: Thu, 15 Feb 2018 16:47:02 -0800
Message-ID: <3f1fd5ba-b052-1d4a-553c-60d54b3a254c@vmware.com>
References: <1518460956-4629-1-git-send-email-aditr@vmware.com>
 <de50c35a-731d-bfb6-efe9-7f2ad83ea7b3@suse.de>
 <8b4f73e6-af5c-d5e2-5425-fbd706a50f66@vmware.com>
 <b5512350-48f1-c4e6-096f-a44307bdf015@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <b5512350-48f1-c4e6-096f-a44307bdf015-l3A5Bk7waGM@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Morey-Chaisemartin <nmoreychaisemartin-l3A5Bk7waGM@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2/13/18 11:59 PM, Nicolas Morey-Chaisemartin wrote:
> 
> 
> Le 14/02/2018 à 07:12, Adit Ranadive a écrit :
>> On 2/13/18 4:24 AM, Nicolas Morey-Chaisemartin wrote:
>>>
>>>
>>> Submitted to stable-v16.
>>> Do you know when OFED 4.8-2 is going out ? Is a new v16.3 release needed right now ?
>>>
>> Thanks Nicolas! I have completed my testing so we would need a new v16.3 release.
>> I can let Vlad know once its generated for him to pick up the new rdma-core.
>>
>> Thanks,
>> Adit
>> --
> 
> Do you mind if I wait til next week for a release ?
> There are no more fixes pending atm, but if you're not in a hurry, I'd like to wait a bit to avoid releasing too often.

Hi Nicolas,

Turns out there is one more patch that needs to go into v16.3. It was an older internal branch which 
I had forgotten about after we moved to a new git repo. Sorry for the mixup and thanks for holding up
the release! I'll send out the other patch.

Thanks,
Adit

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
