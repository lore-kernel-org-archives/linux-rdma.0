From: Bob Biloxi <iambobbiloxi@gmail.com>
Subject: Re: Can a PF driver access the VF config space, BAR(MMIO) etc?
Date: Thu, 25 Sep 2014 12:20:40 +0530
Message-ID: <CANwwZzVrB+OndT4HSwe7eje0dMJqBCZaCCemh4EdPB=3SDtRkw@mail.gmail.com>
References: <CANwwZzUvLHVGshgqrf_w4Pz8wP1H95YAXWLpWFTLD1hWKE_voA@mail.gmail.com>
	<CA+sq2CdKkuOpqwPZdAVT90Xkf_K97ArcUUJjv2f9v4WTDmwXxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <CA+sq2CdKkuOpqwPZdAVT90Xkf_K97ArcUUJjv2f9v4WTDmwXxA@mail.gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: Sunil Kovvuri <sunil.kovvuri@gmail.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Thanks so much for the quick reply! This is really helpful.
I will try to do the same and would get back if i face any difficulties.


Thanks again!

Best Regards,
Bob

On Wed, Sep 24, 2014 at 11:12 PM, Sunil Kovvuri <sunil.kovvuri@gmail.com> wrote:
> If you anyway want to simulate VF functionality in PF driver itself,
> i am not sure why do you need to access VF's config space from PF.
>
> FYI, VF's BAR(MMIO) are not used, MMIO regions are carved using
> VF BARs in PF's SRIOV config space.
>
> VFx BAR0 = PF SRIOV BAR0 + BAR_SIZE * x (VF_NUMBER);
>
> For accessing VF's MMIO regions you can try mapping
> PF's pci_dev->resource[PCI_IOV_RESOURCES] and using above formula
> to get exact MMIO base for corresponding VF.
>
> Regards,
> Sunil.
>
> On Wed, Sep 24, 2014 at 10:10 PM, Bob Biloxi <iambobbiloxi@gmail.com> wrote:
>> Hi,
>>
>> I am new to writing pci sriov drivers. So i could use your help and
>> expertise here....
>>
>> As I understand once sriov is enabled, the PF driver can access the
>> PF(Physical Function) configuration space, BAR(MMIO) etc and the VF
>> driver can access the VF(Virtual Function) configuration space,
>> BAR(MMIO)...
>>
>> Is it possible for a PF driver to access the VF config space, BAR(MMIO)?
>> If yes, can you please point me as to what needs to be done in order
>> to do it(existing driver sources will be really helpful).
>>
>> Now as to why this requirement is if the PF driver is ready and the VF
>> driver is still under development, and I want to simulate the VF
>> functionality from PF itself.
>>
>> It would be of immense help to me if anyone can help me understand my
>> aforementioned query.
>>
>>
>> Thanks a lot!!!
>>
>>
>> Best Regards,
>> Bob
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
