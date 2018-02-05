From: Hal Rosenstock <hal@dev.mellanox.co.il>
Subject: Re: [PATCH] Documentation/ABI: update infiniband sysfs interfaces
Date: Mon, 5 Feb 2018 08:16:55 -0500
Message-ID: <6aca6ebc-4e58-79c7-6767-9e370c8ef71d@dev.mellanox.co.il>
References: <20180201133233.GA21266@mordor.localdomain>
 <64f953cc-7831-1164-28b5-5319e72e600f@dev.mellanox.co.il>
 <20180205071934.GA9185@mordor.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20180205071934.GA9185@mordor.localdomain>
Content-Language: en-US
Sender: linux-doc-owner@vger.kernel.org
To: Aishwarya Pant <aishpant@gmail.com>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Greg KH <gregkh@linuxfoundation.org>, linux-doc@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-rdma@vger.kernel.org

On 2/5/2018 2:19 AM, Aishwarya Pant wrote:
>>> +		cap_mask:	(RO) Port capability mask
>> 2 bits here are settable: IsCommunicationManagementSupported and IsSM.
> Hi
> 
> Sorry, I don't quite understand this. cap_mask is a read only value which
> indicates the supported functions. So the two bits-
> IsCommunicationManagementSupported and IsSM, should not be setttable?

In terms of IB, PortInfo:CapabilityMask is RO from perspective of SM.

In linux, IsSM is settable via open of issmN file. An SM will do this to
set the IsSM bit.

It is similar in terms of IsCommunicationManagementSupported bit where
bit is set when CM module is loaded in kernel (in cm_add_one).

-- Hal

> Aishwarya
> 
> <snip>
> 
