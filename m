From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: srp state in current mainline
Date: Wed, 11 Nov 2015 08:03:46 -0800
Message-ID: <564366E2.8000209@sandisk.com>
References: <20151110171509.GA27781@infradead.org>
 <56436053.7030201@sandisk.com> <20151111154617.GA3754@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20151111154617.GA3754@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 11/11/2015 07:46 AM, Christoph Hellwig wrote:
> On Wed, Nov 11, 2015 at 07:35:47AM -0800, Bart Van Assche wrote:
>> On 11/10/2015 09:15 AM, Christoph Hellwig wrote:
>>> This is a simply xfstests run using XFS on a remote LIO ramdisk.
>>
>> Hello Christoph,
>>
>> Which version of the kernel and LIO were installed at the target side ?
>
> I've tried a couple different one from 4.1-rc3 to latest Linus tree
> from yesterday, and the target side doesn't matter.
>
> I've also bisected things down on the initiator side and the changes to
> enable prefer_fr and register_always seem to be the culprit at least as
> far as 4.3 is concerned.  If I disable both 4.3 is working fine, but
> enabling either one causes frequent map failures.  Just rebuilding
> a new Linus current tree to see if the options help there as well.

Hello Christoph,

The SRP initiator from kernel 4.3 is working fine on my test setup. I 
will start a test with Linus' tree and with the following SRP kernel 
module parameters:

# cat /etc/modprobe.d/ib_srp.conf
options ib_srp cmd_sg_entries=255 register_always=1 prefer_fr=1

Bart.
