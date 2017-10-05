From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: Re: [PATCH for-next 0/8] IB/hfi1, core, rdmavt: Driver fixes for
 10/2/2017
Date: Thu, 5 Oct 2017 06:44:29 -0400
Message-ID: <8601bdaa-53cc-e41f-95e6-483af90848b7@intel.com>
References: <20171002180204.31117.12254.stgit@scvm10.sc.intel.com>
 <1507146261.46071.8.camel@redhat.com>
 <2e195006-92f1-0d6c-1418-5c541f38f8e3@intel.com>
 <20171005070417.GJ25829@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20171005070417.GJ25829@mtr-leonro.local>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Jan Sokolowski <jan.sokolowski@intel.com>, Jakub Byczkowski <jakub.byczkowski@intel.com>, Andrzej Kacprowski <andrzej.kacprowski@intel.com>, linux-rdma@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, Stable@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Don Hiatt <don.hiatt@intel.com>, Niranjana Vishwanathapura <Niranjana.Vishwanathapura@intel.com>, Sebastian Sanchez <sebastian.sanchez@intel.com>
List-Id: linux-rdma@vger.kernel.org

On 10/5/2017 3:04 AM, Leon Romanovsky wrote:
> On Wed, Oct 04, 2017 at 09:22:06PM -0400, Dennis Dalessandro wrote:
>> On 10/4/2017 3:44 PM, Doug Ledford wrote:
>>> On Mon, 2017-10-02 at 11:03 -0700, Dennis Dalessandro wrote:
>>>> Hi Doug,
>>>> There are a couple fixes in here that would have been nice to get
>>>> into the RC
>>>> cycle, including one marked stable. However I think you will find
>>>> them to be
>>>> too many LOC for an rc-4 submission so I have sent them in one series
>>>> for-next.
>>>> Patches 2,3,4 and 5 are the fixes. Patch 2 is small but it's not
>>>> really that
>>>> important to the end user.
>>>>
>>>> There are some clean ups in here from Don from the 16B changes. One
>>>> takes care
>>>> of some sparse warnings and the other two are from a WARN_ON_ONCE
>>>> that needed
>>>> special cased for OPA.
>>>>
>>>> Patches can can also be found in my GitHub repo at:
>>>> https://github.com/ddalessa/kernel/tree/for-4.15
>>>
>>> Hi Denny,
>>>
>>> I didn't process that you mixed for-rc and for-next stuff in a single
>>> thread before I had gone through and looked at the patches and
>>> processed them.  So, this time they all went to for-next.  In the
>>> future, you really need patches you want in for-rc separate from the
>>> patches intended for for-next.
>>
>> Maybe I wasn't too clear, I didn't intend any of those to go for-rc. So yep
>> for-next was the right target.
>>
>> I would have liked to get the fixes into -rc but they were just too complex
>> for this late in the game is all I meant.
> 
> IMHO, the number of LOCs shouldn't be the gating factor for -rc, but the
> severity of fixes yes.

Not the gating factor necessarily, but a factor that has to be be 
weighed against the severity of the bug being fixed. As we get into 
later -rc cycles the bar for risk vs reward gets raised, not that there 
should be a limit of X LOC for -rc whatever it's more of an overall 
assessment of the risk of causing more harm than good.

-Denny
