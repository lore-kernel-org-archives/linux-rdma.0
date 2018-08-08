From: "Alex G." <mr.nuke.me@gmail.com>
Subject: Re: [PATCH v6 8/9] net/mlx5: Do not call pcie_print_link_status()
Date: Wed, 8 Aug 2018 11:33:51 -0500
Message-ID: <79264a38-e3e4-d270-95df-a09047f7a15e@gmail.com>
References: <CAErSpo4PK+SQLNfdkLNt9eLc7bpbxbkZCsa8T-tQpid601n0SQ@mail.gmail.com>
 <20180806232600.25694-1-mr.nuke.me@gmail.com>
 <20180806232600.25694-8-mr.nuke.me@gmail.com>
 <20180808060848.GQ13378@mtr-leonro.mtl.com>
 <05056a70-ee78-ea3c-0b9b-6d64a8663b11@mellanox.com>
 <20180808154142.GZ13378@mtr-leonro.mtl.com>
 <5578cd9a-e4f0-85ab-4a86-bfa23eec136c@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5578cd9a-e4f0-85ab-4a86-bfa23eec136c@mellanox.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Tal Gilboa <talgi@mellanox.com>, Leon Romanovsky <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, bhelgaas@google.com, jakub.kicinski@netronome.com, keith.busch@intel.com, alex_gagniuc@dellteam.com, austin_bolen@dell.com, shyam_iyer@dell.com, Ariel Elior <ariel.elior@cavium.com>, everest-linux-l2@cavium.com, "David S. Miller" <davem@davemloft.net>, Michael Chan <michael.chan@broadcom.com>, Ganesh Goudar <ganeshgr@chelsio.com>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Tariq Toukan <tariqt@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, Dirk van der Merwe <dirk.vandermerwe@netronome.com>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org, linux-rdma@vger.kernel.org, oss-drivers@netronome.com
List-Id: linux-rdma@vger.kernel.org



On 08/08/2018 10:56 AM, Tal Gilboa wrote:
> On 8/8/2018 6:41 PM, Leon Romanovsky wrote:
>> On Wed, Aug 08, 2018 at 05:23:12PM +0300, Tal Gilboa wrote:
>>> On 8/8/2018 9:08 AM, Leon Romanovsky wrote:
>>>> On Mon, Aug 06, 2018 at 06:25:42PM -0500, Alexandru Gagniuc wrote:
>>>>> This is now done by the PCI core to warn of sub-optimal bandwidth.
>>>>>
>>>>> Signed-off-by: Alexandru Gagniuc <mr.nuke.me@gmail.com>
>>>>> ---
>>>>>    drivers/net/ethernet/mellanox/mlx5/core/main.c | 4 ----
>>>>>    1 file changed, 4 deletions(-)
>>>>>
>>>>
>>>> Thanks,
>>>> Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
>>>>
>>>
>>> Alex,
>>> I loaded mlx5 driver with and without these series. The report in 
>>> dmesg is
>>> now missing. From what I understood, the status should be reported at 
>>> least
>>> once, even if everything is in order.
>>
>> It is not what this series is doing and it removes prints completely if
>> fabric can deliver more than card is capable.
>>
>>> We need this functionality to stay.
>>
>> I'm not sure that you need this information in driver's dmesg output,
>> but most probably something globally visible and accessible per-pci
>> device.
> 
> Currently we have users that look for it. If we remove the dmesg print 
> we need this to be reported elsewhere. Adding it to sysfs for example 
> should be a valid solution for our case.

I think a stop-gap measure is to leave the pcie_print_link_status() call 
in drivers that really need it for whatever reason. Implementing a 
reliable reporting through sysfs might take some tinkering, and I don't 
think it's a sufficient reason to block the heart of this series -- 
being able to detect bottlenecks and link downtraining.

Alex

>>
>>>
>>> net-next (dmesg output for 07:00.0):
>>> [270498.625351] mlx5_core 0000:07:00.0: firmware version: 14.22.4020
>>> [270498.632130] mlx5_core 0000:07:00.0: 63.008 Gb/s available PCIe 
>>> bandwidth
>>> (8 GT/s x8 link)
>>> [270499.169533] (0000:07:00.0): E-Switch: Total vports 9, per vport: max
>>> uc(1024) max mc(16384)
>>> [270499.182358] mlx5_core 0000:07:00.0: Port module event: module 0, 
>>> Cable
>>> plugged
>>>
>>> net-next + patches (dmesg output for 07:00.0):
>>> [  331.608472] mlx5_core 0000:07:00.0: firmware version: 14.22.4020
>>> [  332.564938] (0000:07:00.0): E-Switch: Total vports 9, per vport: max
>>> uc(1024) max mc(16384)
>>> [  332.616271] mlx5_core 0000:07:00.0: Port module event: module 0, 
>>> Cable
>>> plugged
>>>
>>>
