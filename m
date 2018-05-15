From: Selvin Xavier <selvin.xavier@broadcom.com>
Subject: Re: [PATCH 6/6] infiniband: qplib_fp: Use dev_fmt
Date: Tue, 15 May 2018 20:31:15 +0530
Message-ID: <CA+sbYW19fDrSnRiGt8JEhC6OUpziYJtXT3wUe6qENbTXnDVo+Q@mail.gmail.com>
References: <cover.1525878372.git.joe@perches.com> <51c5082a4add7520b4fac54e58ca26a8156bf5e8.1525878372.git.joe@perches.com>
 <117ed9198ff46889d3e66a0d501fb574e60544ed.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <117ed9198ff46889d3e66a0d501fb574e60544ed.camel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Joe Perches <joe@perches.com>, Devesh Sharma <devesh.sharma@broadcom.com>, Somnath Kotur <somnath.kotur@broadcom.com>, Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>, x86@kernel.org, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 15, 2018 at 8:10 PM, Doug Ledford <dledford@redhat.com> wrote:
> On Wed, 2018-05-09 at 08:15 -0700, Joe Perches wrote:
>> Convert the embedded dev_<level> uses to use the new dev_fmt
>> prefix and remove the prefix from the formats.
>>
>> Miscellanea:
>>
>> o Add missing terminating newlines to avoid possible interleaving
>> o Realign arguments
>>
>> Signed-off-by: Joe Perches <joe@perches.com>
>
> I don't see any problem with this patch.  For the IB part:
>
> Acked-by: Doug Ledford <dledford@redhat.com>
>
>
Acked-by: Selvin Xavier <selvin.xavier@broadcom.com>
