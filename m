From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC ABI V6 00/14] SG-based RDMA ABI Proposal
Date: Mon, 19 Dec 2016 10:12:28 +0200
Message-ID: <4a42e1a4-e848-8beb-1d8e-655a616990fc@mellanox.com>
References: <1481461088-56355-1-git-send-email-matanb@mellanox.com>
 <20161219004854.GA12723@phlsvsds.ph.intel.com>
 <20161219055037.GO1074@mtr-leonro.local>
 <2807E5FD2F6FDA4886F6618EAC48510E3C611539@CRSMSX101.amr.corp.intel.com>
 <20161219062841.GP1074@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161219062841.GP1074-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 19/12/2016 08:28, Leon Romanovsky wrote:
> On Mon, Dec 19, 2016 at 06:07:55AM +0000, Weiny, Ira wrote:
>>>> These don't apply to any Doug branches I have tried.  (I don't see a
>>>> for-4.9-fixed branch at:)
>>>>
>>>> https://git.kernel.org/cgit/linux/kernel/git/dledford/rdma.git/refs/he
>>>> ads
>>>>
>>>> Doug, have you accepted Leon's IOCTL series?
>>>
>>> Yes, Doug accepted it.
>>>
>>
>> Do you know what branch they are on?
>
> It puzzled me too, but since the code is available in Matan's repo [1],
> I didn't bother myself.
>

Actually, I couldn't find Leon's patches on any official branch, so I've 
just applied them myself. Anyway, I also manage a tag named abi-devel in 
my github (which represents the on-going development).

> [1] https://github.com/matanb10/linux abi_rfc_pre_v6
>
>>
>> Ira
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
