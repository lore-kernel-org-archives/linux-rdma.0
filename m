From: Aaron Knister <aaron.s.knister@nasa.gov>
Subject: Re: [PATCH v2] avoid race condition between start_xmit and
 cm_rep_handler
Date: Fri, 24 Aug 2018 08:34:47 -0400
Message-ID: <62883554-a296-6d70-4aa3-255e773c1ecd@nasa.gov>
References: <1534541486-16263-1-git-send-email-aaron.s.knister@nasa.gov>
 <CAAk-MO97rinpQXhyy7VZA6HWNwm94UuWAFnLFOSb4mj1wW4fQw@mail.gmail.com>
 <20180820162800.GA25543@ziepe.ca>
 <8c98f997-54ec-d060-8918-a073663c646f@nasa.gov>
 <5646c41e-cfa2-d9f7-0722-0ddfc4537676@nasa.gov>
 <0e880f0d-ce8d-1cce-efb2-7c832e029569@nasa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <0e880f0d-ce8d-1cce-efb2-7c832e029569@nasa.gov>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>, Erez Shitrit <erezsh@dev.mellanox.co.il>
Cc: RDMA mailing list <linux-rdma@vger.kernel.org>, stable@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, John Fleck <john.fleck@intel.com>, Feras Daoud <ferasda@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

I just had a chance to do additional testing of the v3 patch. Giving it 
30 new test iterations showed it's performance (based on the "organic" 
reproducer) to be on par with and marginally better than the v2 patch. 
With that said, I'll formally submit the v3 patch.

-Aaron

On 8/23/18 7:25 PM, Aaron Knister wrote:
> I had a small window to test the v3 patch (applied to the 4.4.120 
> kernel) at scale and it does appear to fix the issue, so that's good. 
> One area of concern, though, is the testing data suggests (and this 
> isn't really scientific at all since there are many variables) the v3 
> patch appears to be 10% slower than the v2 patch. The "organic" test 
> involves creating a large number of empty files in a GPFS filesystem and 
> exacerbating the race condition with GPFS RPC traffic. My sample sizes 
> aren't large, though (26 iterations for the v2 patch and 8 for the v3 
> patch due to time constraints). I don't really have a preference for 
> either approach. What do folks think?
> 
> -Aaron
> 
> On 8/20/18 3:20 PM, Aaron Knister wrote:
>> It seems to fix the issue based on tests with my synthetic reproducer 
>> which consists of two carefully placed sleeps-- one in start_xmit and 
>> another before cm_rep_handler to force open the race window. In order 
>> to test it organically I need to commandeer many hundreds of nodes in 
>> our cluster which can be fairly disruptive to our user community. I'll 
>> send over v3 as an RFC and it would be great to get feedback about 
>> whether or not the patch is acceptable. If it is, I'll work on 
>> scheduling an at-scale test after which I'll submit v3. I think the 
>> odds are very low the synthetic reproducer would indicate this problem 
>> as fixed but the real world test would still experience the problem. I 
>> try to be thorough, though.
>>
>> -Aaron
>>
>> On 8/20/18 1:40 PM, Aaron Knister wrote:
>>> On 8/20/18 12:28 PM, Jason Gunthorpe wrote:
>>>> On Mon, Aug 20, 2018 at 09:36:53AM +0300, Erez Shitrit wrote:
>>>>> Hi,
>>>>>
>>>>> Did you check the option to hold the netif_tx_lock_xxx() in
>>>>> ipoib_cm_rep_handler function (over the line
>>>>> set_bit(IPOIB_FLAG_OPER_UP)) instead of in the send data path flow?
>>>>
>>>> That does seem better, then the test_bit in the datapath could become
>>>> non-atomic too :)
>>>>
>>>> Jason
>>>
>>> Thanks for the feedback! I've not tried that but I certainly can.
>>>
>>> -Aaron
>>>
>>
> 

-- 
Aaron Knister
NASA Center for Climate Simulation (Code 606.2)
Goddard Space Flight Center
(301) 286-2776
