From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: mainline build: 15 warnings 0 failures (mainline/v4.16-rc2-64-gaf3e79d)
Date: Wed, 7 Mar 2018 00:25:55 +0100
Message-ID: <CAK8P3a2-zq95wnNYDSeTubkhr4Oc_YTSHX-NjvbD35iVNk+fWg@mail.gmail.com>
References: <5a8c6a34.8880a70a.2a9a1.afc7@mx.google.com> <CAK8P3a0OaN6QjPdTXXXzMeYQt+WnMfvVuhza5Rb2wqdq_iEFVA@mail.gmail.com>
 <7b724d51-52b8-6cbf-2a9d-f44f3de28dc8@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7b724d51-52b8-6cbf-2a9d-f44f3de28dc8@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Olof's autobuilder <build@lixom.net>, Olof Johansson <olof@lixom.net>, Kernel Build Reports Mailman List <kernel-build-reports@lists.linaro.org>, linux-rdma <linux-rdma@vger.kernel.org>, Selvin Xavier <selvin.xavier@broadcom.com>, Devesh Sharma <devesh.sharma@broadcom.com>, Somnath Kotur <somnath.kotur@broadcom.com>, Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 21, 2018 at 3:42 PM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
>
>
> On Wednesday 21 February 2018 06:12 PM, Arnd Bergmann wrote:
>> On Tue, Feb 20, 2018 at 7:34 PM, Olof's autobuilder <build@lixom.net> wrote:
>>> Here are the build results from automated periodic testing.
>>>
>>> The tree being built was mainline, found at:
>>>
>>> URL: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
>>>
>>>
>>> Warnings:
>>>
>>>         arm64.allmodconfig:
>>> include/uapi/linux/byteorder/big_endian.h:31:52: warning: passing argument 1 of '__fswab64' makes integer from pointer without a cast [-Wint-conversion]
>>
>> I sent two patches to the bnxt_re maintainers yesterday. I expect them
>> to get applied
>> soon, but haven't heard back yet.
>>
>>> WARNING: modpost: missing MODULE_LICENSE() in drivers/phy/qualcomm/phy-qcom-ufs.o
>>
>> Still waiting for Kishon to apply an older patch I sent for this.
>
> I had merged it locally. Now pushed everything.

Hi Kishon,

kernelci still reports it as one of the remaining warnings for v4.16-rc,
any chance you can send this as a bugfix for the current release?

       Arnd
