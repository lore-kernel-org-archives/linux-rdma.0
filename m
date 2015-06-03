From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next V2 8/9] IB/mlx4: Support extended create_cq and
 query_device uverbs
Date: Wed, 3 Jun 2015 11:57:12 +0300
Message-ID: <CAAKD3BARPocK1zZ2nYV0xWHqEASJTYbp1aQxwymi-TYTyK_vGA@mail.gmail.com>
References: <1433074457-26437-1-git-send-email-ogerlitz@mellanox.com>
	<1433074457-26437-9-git-send-email-ogerlitz@mellanox.com>
	<20150601165649.GC14391@obsidianresearch.com>
	<CAAKD3BBsTFYKwOBK+6u04x6deRYzjYESJzbpyy83UtoChZhpOA@mail.gmail.com>
	<20150602170736.GA17776@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150602170736.GA17776-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 2, 2015 at 8:07 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Tue, Jun 02, 2015 at 10:21:47AM +0300, Matan Barak wrote:
>> On Mon, Jun 1, 2015 at 7:56 PM, Jason Gunthorpe
>> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>> > On Sun, May 31, 2015 at 03:14:16PM +0300, Or Gerlitz wrote:
>> >> From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> >>
>> >> Add support for ib_uverbs_ex_create_cq and ib_uverbs_ex_query_device
>> >> by setting the appropriate bit in uverbs_ex_cmd_mask.
>> >
>> > Why is this a seperate patch? Surely the bits should be or'd in the patches
>> > that actually include the code to do the new commands?
>> >
>>
>> Although this patch can stand on its own (requesting unsupported flags
>> will just fail and the
>> comp_mask of uhw's will be disabled), there's no real value for not
>> squashing it into the other mlx4 patches.
>
> Then there is something wrong with this 'uverbs_ex_cmd_mask' stuff -
> the bit should be clear if the driver cannot handle the ex inputs, but
> these patches make all drivers handle the ex style (by checking
> flags), so all drivers should have some of the bits set..
>

That's a general comment regarding the extension mechanism.
Since by nature the extended verbs as extendible, one consumer could support
A and B while the other only supports A, but they both indicate they support
this extension verb.
You could argue that if the "flags" field wasn't tested, we would have need this
uverbs_ex_cmd_mask - but because it could be also used by kernel consumers,
this check is necessary.

> An extended command that doesn't use any extended features should
> transparently degrade to the normal command as often as possible.
>

That means that uverbs_ex_cmd_mask should only be used on extended commands that
are user-space specific.
Anyway, we could add these  IB_USER_VERBS_EX_CMD flags to all vendors,
but IMHO this general problem doesn't relate to this series,
which is only about adding timestamp support.

> Jason

Thanks for your comments.

Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
