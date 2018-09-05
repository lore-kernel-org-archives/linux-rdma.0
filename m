From: "Alex G." <mr.nuke.me@gmail.com>
Subject: Re: [PATCH 1/9] PCI: sysfs: Export available PCIe bandwidth
Date: Wed, 5 Sep 2018 08:52:31 -0500
Message-ID: <122e86e4-7c0a-8539-75dc-1515c1b8c68f@gmail.com>
References: <20180903180242.14504-1-mr.nuke.me@gmail.com>
 <20180903180242.14504-2-mr.nuke.me@gmail.com>
 <20180905082605.69d9e5a0@shemminger-XPS-13-9360>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180905082605.69d9e5a0@shemminger-XPS-13-9360>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: linux-pci@vger.kernel.org, bhelgaas@google.com, keith.busch@intel.com, alex_gagniuc@dellteam.com, austin_bolen@dell.com, shyam_iyer@dell.com, Ariel Elior <ariel.elior@cavium.com>, everest-linux-l2@cavium.com, "David S. Miller" <davem@davemloft.net>, Michael Chan <michael.chan@broadcom.com>, Ganesh Goudar <ganeshgr@chelsio.com>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Tariq Toukan <tariqt@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leon@kernel.org>, Jakub Kicinski <jakub.kicinski@netronome.com>, Dirk van der Merwe <dirk.vandermerwe@netronome.com>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org, linux-rdma@vger.kernel.org, oss-drivers@netronome.com
List-Id: linux-rdma@vger.kernel.org

On 09/05/2018 02:26 AM, Stephen Hemminger wrote:
> On Mon,  3 Sep 2018 13:02:28 -0500
> Alexandru Gagniuc <mr.nuke.me@gmail.com> wrote:
> 
>> For certain bandwidth-critical devices (e.g. multi-port network cards)
>> it is useful to know the available bandwidth to the root complex. This
>> information is only available via the system log, which doesn't
>> account for link degradation after probing.
>>
>> With a sysfs attribute, we can computes the bandwidth on-demand, and
>> will detect degraded links.
>>
>> Signed-off-by: Alexandru Gagniuc <mr.nuke.me@gmail.com>
> 
> In other places (like /sys/class/net/eth0/speed) only the raw value is printed
> without suffix.  The general convention in sysfs is that it should be one value
> per file and in more raw format.  So why not just print it in bits/sec without
> suffix?

I wanted to be consistent with other PCIe exports that use units.For 
example:

/sys/devices/pci0000:3a/0000:3a:00.0/0000:3b:00.0/0000:3c:05.0/max_link_speed:8 
GT/s
/sys/devices/pci0000:3a/0000:3a:00.0/0000:3b:00.0/0000:3c:05.0/current_link_speed:2.5 
GT/s
/sys/bus/pci/slots/182/cur_bus_speed:2.5 GT/s PCIe
/sys/bus/pci/slots/182/max_bus_speed:8.0 GT/s PCIe
