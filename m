From: <Alex_Gagniuc@Dellteam.com>
Subject: Re: [PATCH 1/9] PCI: sysfs: Export available PCIe bandwidth
Date: Wed, 3 Oct 2018 22:00:19 +0000
Message-ID: <f9fbc8babbb344eca593a3f8b0d096d9@ausx13mps321.AMER.DELL.COM>
References: <20180903180242.14504-1-mr.nuke.me@gmail.com>
 <20180903180242.14504-2-mr.nuke.me@gmail.com>
 <20181003213054.GH120535@bhelgaas-glaptop.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: helgaas@kernel.org, mr.nuke.me@gmail.com
Cc: linux-pci@vger.kernel.org, bhelgaas@google.com, keith.busch@intel.com, Austin.Bolen@dell.com, Shyam.Iyer@dell.com, ariel.elior@cavium.com, everest-linux-l2@cavium.com, davem@davemloft.net, michael.chan@broadcom.com, ganeshgr@chelsio.com, jeffrey.t.kirsher@intel.com, tariqt@mellanox.com, saeedm@mellanox.com, leon@kernel.org, jakub.kicinski@netronome.com, dirk.vandermerwe@netronome.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org, linux-rdma@vger.kernel.org, oss-drivers@netronome.com, stephen@networkplumber.org, mj@ucw.cz
List-Id: linux-rdma@vger.kernel.org

On 10/03/2018 04:31 PM, Bjorn Helgaas wrote:=0A=
> =0A=
> [EXTERNAL EMAIL]=0A=
> Please report any suspicious attachments, links, or requests for sensitiv=
e information.=0A=
> =0A=
> =0A=
> [+cc Stephen, Martin (for possible lspci changes)]=0A=
> =0A=
> Hi Alexandru,=0A=
> =0A=
> On Mon, Sep 03, 2018 at 01:02:28PM -0500, Alexandru Gagniuc wrote:=0A=
>> For certain bandwidth-critical devices (e.g. multi-port network cards)=
=0A=
>> it is useful to know the available bandwidth to the root complex. This=
=0A=
>> information is only available via the system log, which doesn't=0A=
>> account for link degradation after probing.=0A=
>>=0A=
>> With a sysfs attribute, we can computes the bandwidth on-demand, and=0A=
>> will detect degraded links.=0A=
>>=0A=
>> Signed-off-by: Alexandru Gagniuc <mr.nuke.me@gmail.com>=0A=
>> ---=0A=
>>   drivers/pci/pci-sysfs.c | 13 +++++++++++++=0A=
>>   1 file changed, 13 insertions(+)=0A=
>>=0A=
>> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c=0A=
>> index 9ecfe13157c0..6658e927b1f5 100644=0A=
>> --- a/drivers/pci/pci-sysfs.c=0A=
>> +++ b/drivers/pci/pci-sysfs.c=0A=
>> @@ -218,6 +218,18 @@ static ssize_t current_link_width_show(struct devic=
e *dev,=0A=
>>   }=0A=
>>   static DEVICE_ATTR_RO(current_link_width);=0A=
>>   =0A=
>> +static ssize_t available_bandwidth_show(struct device *dev,=0A=
>> +				       struct device_attribute *attr, char *buf)=0A=
>> +{=0A=
>> +	struct pci_dev *pci_dev =3D to_pci_dev(dev);=0A=
>> +	u32 bw_avail;=0A=
>> +=0A=
>> +	bw_avail =3D pcie_bandwidth_available(pci_dev, NULL, NULL, NULL);=0A=
>> +=0A=
>> +	return sprintf(buf, "%u.%03u Gb/s\n", bw_avail / 1000, bw_avail % 1000=
);=0A=
>> +}=0A=
>> +static DEVICE_ATTR_RO(available_bandwidth);=0A=
> =0A=
> Help me understand this.  We already have these sysfs attributes:=0A=
> =0A=
>    max_link_speed          # eg, 16 GT/s=0A=
>    max_link_width          # eg, 8=0A=
>    current_link_speed      # eg, 16 GT/s=0A=
>    current_link_width      # eg, 8=0A=
> =0A=
> so I think the raw materials are already exposed.=0A=
> > The benefits I see for this new file are that=0A=
> =0A=
>    - pcie_bandwidth_available() does the work of traversing up the=0A=
>      tree, doing the computations (link width * speed, reduced by=0A=
>      encoding overhead), and finding the minimum, and=0A=
> =0A=
>    - it re-traverses the path every time we look at it, while the=0A=
>      boot-time check is a one-time event.=0A=
> =0A=
> In principle this could all be done in user space with the attributes=0A=
> that are already exported.  There's some precedent for things like=0A=
> this in lspci, e.g., "NUMA node" [1], and lspci might even be a more=0A=
> user-friendly place for users to look for this, as opposed to=0A=
> searching through sysfs.=0A=
=0A=
Parsing the endpoint to root port bandwidth is, in principle, possible =0A=
from userspace. It's just that in practice it's very clumsy to do, and, =0A=
as you pointed out, not that reliable.=0A=
=0A=
I understand it's not information that all users would jump in the air =0A=
to know. However, it was important enough for certain use cases, that =0A=
the kernel already has a very reliable way to calculate it.=0A=
=0A=
It seems to me that the most elegant way is to let the kernel tell us, =0A=
since the kernel already has this facility. To quote one of the texts =0A=
under Documentation/, it is an elegant way to "avoid reinventing kernel =0A=
wheels in userspace".=0A=
=0A=
Alex=0A=
=0A=
> [1] https://git.kernel.org/pub/scm/utils/pciutils/pciutils.git/commit/?id=
=3D90ec4a6d0ae8=0A=
> =0A=
>>   static ssize_t secondary_bus_number_show(struct device *dev,=0A=
>>   					 struct device_attribute *attr,=0A=
>>   					 char *buf)=0A=
>> @@ -786,6 +798,7 @@ static struct attribute *pcie_dev_attrs[] =3D {=0A=
>>   	&dev_attr_current_link_width.attr,=0A=
>>   	&dev_attr_max_link_width.attr,=0A=
>>   	&dev_attr_max_link_speed.attr,=0A=
>> +	&dev_attr_available_bandwidth.attr,=0A=
>>   	NULL,=0A=
>>   };=0A=
>>   =0A=
>> -- =0A=
>> 2.17.1=0A=
>>=0A=
> =0A=
=0A=
