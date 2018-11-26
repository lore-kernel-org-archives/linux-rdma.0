From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH net-next] net: remove unsafe skb_insert()
Date: Sun, 25 Nov 2018 21:31:34 -0800
Message-ID: <e476d0d1-e6a4-a012-ea36-126da1533a67@gmail.com>
References: <20181125162623.127762-1-edumazet@google.com>
 <20181125.102936.907000798531091562.davem@davemloft.net>
 <CANn89i+mEYyLWt74jK-0ruUjHafgAPMdFKJGgM37B-iuZzk12g@mail.gmail.com>
 <20181125.195246.1813633762107745866.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181125.195246.1813633762107745866.davem@davemloft.net>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>, edumazet@google.com
Cc: netdev@vger.kernel.org, eric.dumazet@gmail.com, faisal.latif@intel.com, dledford@redhat.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



On 11/25/2018 07:52 PM, David Miller wrote:
> 
> I fixed up the build in your original patch and am about to push that
> out.

Thanks David, sorry for this, I should have compiled the damn thing :/
