From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: cx4 sriov problem in stable 4.14.47
Date: Wed, 20 Jun 2018 15:28:43 +0300
Message-ID: <821b004b-7303-f08e-10e6-eb57283b13c0@grimberg.me>
References: <1ae538be-2699-e0cc-adef-2235489472ab@grimberg.me>
 <20180620120101.GE7557@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180620120101.GE7557@mtr-leonro.mtl.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, Stable <stable@vger.kernel.org>, Roy Shterman <roys@lightbitslabs.com>
List-Id: linux-rdma@vger.kernel.org


>> Seems that CX4 (Ethernet) sriov ports probe with link down in the latest
>> stable 4.14 kernel. I upgrated firmware but with no luck :(
>>
>> Has anyone seen this issue as well?
> 
> I'm shooting to the dark, isn't this related to commit
> e3ca34880652250f524022ad89e516f8ba9a805b ?

Probably not, this only effects rdma ulps what want to map
to irq affinities. This is an ethernet vf probed with link down.
