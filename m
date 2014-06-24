From: Bob Biloxi <iambobbiloxi@gmail.com>
Subject: Re: mlx4 - query regarding PF VF functionality division
Date: Tue, 24 Jun 2014 19:12:51 +0530
Message-ID: <CANwwZzXc2UyYxGX2X+O38jTVki70HrP71FBWbc4dTyt9nEN0nA@mail.gmail.com>
References: <CANwwZzWsjQwZB5Cc4Hyv2HQOLhAx6ycjf32UQG55zVX=Kmbi6Q@mail.gmail.com>
	<CAJZOPZ+FUneDDKMh0O2aZLYeDTcH8cHA7ati5wzi7Ycgc5wFXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <CAJZOPZ+FUneDDKMh0O2aZLYeDTcH8cHA7ati5wzi7Ycgc5wFXQ@mail.gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: Or Gerlitz <or.gerlitz@gmail.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

> Not really, but let's take EIM approach, what's your goal/mission?
Let's say I am going through code to understand only the PF related
functionality without bothering about VF, what are the things I need
to keep in mind.
I mean do i need to :

a. Go through all the files in mlx4
b. If the code is not specifically under mlx4_is_master, I still need
to understand it because it is also part of PF driver
c. I can ignore the logic which executes if mlx4_is_master is false,
because that would be the VF code

Thanks for the help!!




On Mon, Jun 23, 2014 at 5:30 PM, Or Gerlitz <or.gerlitz@gmail.com> wrote:
> On Mon, Jun 23, 2014 at 12:33 PM, Bob Biloxi <iambobbiloxi@gmail.com> wrote:
> [...]
>> Is there any way we can clearly separate the files that are used by PF
>> vs the files that are used by VF in the (drivers/net/ethernet/mlx4
>> sub-directory)?
> [...]
>
> Not really, but let's take EIM approach, what's your goal/mission?
>
> Or.
