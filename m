From: Hal Rosenstock <hal@dev.mellanox.co.il>
Subject: Re: [RFC PATCH v2 00/13] SELinux support for Infiniband RDMA
Date: Tue, 12 Apr 2016 01:12:06 -0400
Message-ID: <570C83A6.8070600@dev.mellanox.co.il>
References: <1459985638-37233-1-git-send-email-danielj@mellanox.com>
 <20160411201155.GC371@obsidianresearch.com>
 <DB5PR05MB111168B6670B36F12979705BC4940@DB5PR05MB1111.eurprd05.prod.outlook.com>
 <20160411221210.GA5861@obsidianresearch.com>
 <DB5PR05MB1111E6A72480FF78AAB12747C4940@DB5PR05MB1111.eurprd05.prod.outlook.com>
 <20160411231250.GB5861@obsidianresearch.com>
 <DB5PR05MB1111F04641E58609E51A9630C4940@DB5PR05MB1111.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <DB5PR05MB1111F04641E58609E51A9630C4940@DB5PR05MB1111.eurprd05.prod.outlook.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Daniel Jurgens <danielj@mellanox.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: "selinux@tycho.nsa.gov" <selinux@tycho.nsa.gov>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Yevgeny Petrilin <yevgenyp@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On 4/11/2016 7:35 PM, Daniel Jurgens wrote:
> On 4/11/2016 6:12 PM, Jason Gunthorpe wrote:
>> On Mon, Apr 11, 2016 at 10:30:54PM +0000, Daniel Jurgens wrote:
>>
>> Like I said, the user facing name should be QP0 in that case.
>>
>> Jason
>>
> 
> OK, I'll change idbev to ibendport and smi to qp0, or qpzero if the
> SELinux user space code doesn't allow numbers in access vector identifiers.

Another possible name for this is smp.

-- Hal

