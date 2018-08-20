From: Aaron Knister <aaron.s.knister@nasa.gov>
Subject: Re: [PATCH v2] avoid race condition between start_xmit and
 cm_rep_handler
Date: Mon, 20 Aug 2018 13:40:36 -0400
Message-ID: <8c98f997-54ec-d060-8918-a073663c646f@nasa.gov>
References: <1534541486-16263-1-git-send-email-aaron.s.knister@nasa.gov>
 <CAAk-MO97rinpQXhyy7VZA6HWNwm94UuWAFnLFOSb4mj1wW4fQw@mail.gmail.com>
 <20180820162800.GA25543@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180820162800.GA25543@ziepe.ca>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>, Erez Shitrit <erezsh@dev.mellanox.co.il>
Cc: RDMA mailing list <linux-rdma@vger.kernel.org>, stable@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, John Fleck <john.fleck@intel.com>, Feras Daoud <ferasda@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On 8/20/18 12:28 PM, Jason Gunthorpe wrote:
> On Mon, Aug 20, 2018 at 09:36:53AM +0300, Erez Shitrit wrote:
>> Hi,
>>
>> Did you check the option to hold the netif_tx_lock_xxx() in
>> ipoib_cm_rep_handler function (over the line
>> set_bit(IPOIB_FLAG_OPER_UP)) instead of in the send data path flow?
> 
> That does seem better, then the test_bit in the datapath could become
> non-atomic too :)
> 
> Jason

Thanks for the feedback! I've not tried that but I certainly can.

-Aaron

-- 
Aaron Knister
NASA Center for Climate Simulation (Code 606.2)
Goddard Space Flight Center
(301) 286-2776
