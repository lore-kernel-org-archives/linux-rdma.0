From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: Re: perftest proprietary files
Date: Thu, 27 Jul 2017 17:33:14 +0200
Message-ID: <8bff5295-19f9-059a-e5e6-997b6297b322@suse.de>
References: <2411a5c0-84f8-124e-83ce-1ee587dcf4ce@suse.de>
 <DB6PR05MB3493378C569E416783246ED4A9BE0@DB6PR05MB3493.eurprd05.prod.outlook.com>
 <1501165194.4572.32.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501165194.4572.32.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Zohar Ben Aharon <zoharb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

This is what I meant.
I agree Mellanox has all right to keep their copyright in, but in the current form, it kinda prevents redistribution of the compilation files.

Adding a GPL (or BSD) with the Mellanox copyright clears up things.

Nicolas

Le 27/07/2017 à 16:19, Benjamin Drung a écrit :
> Hi Nicolas,
>
> can Mellanox adjust the header of the files? Currently it says:
>
> #
> # Copyright (C) Mellanox Technologies Ltd. 2001-2011.  ALL RIGHTS RESERVED.
> # This software product is a proprietary product of Mellanox Technologies Ltd.
> # (the "Company") and all right, title, and interest and to the software product,
> # including all associated intellectual property rights, are and shall
> # remain exclusively with the Company.
> #
> # This software product is governed by the End User License Agreement
> # provided with the software product.
> # $COPYRIGHT$
> # $HEADER$
> #
>
> but since it is gpl/bsd (as you said), the header should read something like:
>
> # Copyright (C) Mellanox Technologies Ltd. 2001-2011.  All rights
> reserved.
> #
> # This software is available to you under a choice of one of
> two
> # licenses.  You may choose to be licensed under the terms of the
> GNU
> # General Public License (GPL) Version 2, available from the file
> #
> COPYING in the main directory of this source tree, or the
> # OpenIB.org
> BSD license below:
> #
> #     Redistribution and use in source and binary
> forms, with or
> #     without modification, are permitted provided that
> the following
> #     conditions are met:
> #
> #      - Redistributions of
> source code must retain the above
> #        copyright notice, this list
> of conditions and the following
> #        disclaimer.
> #
> #      -
> Redistributions in binary form must reproduce the above
> #       
> copyright notice, this list of conditions and the following
> #       
> disclaimer in the documentation and/or other materials
> #        provided
> with the distribution.
> #
> # THE SOFTWARE IS PROVIDED "AS IS", WITHOUT
> WARRANTY OF ANY KIND,
> # EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
> THE WARRANTIES OF
> # MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE
> AND
> # NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
> HOLDERS
> # BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
> IN AN
> # ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
> IN
> # CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> #
> SOFTWARE.
>
> Am Donnerstag, den 27.07.2017, 12:35 +0000 schrieb Zohar Ben Aharon:
>> Hi Nicolas,
>>
>>
>> I've verified your issue, 
>> Mellanox provide perftest to be under gpl/bsd license.
>> since Mellanox is the maintainer and release perftest as an open
>> source SW it still can have copyrights on each file that was written
>> or approved by its developers,
>> So the headers should remain and declared as Mellanox propriety.
>>
>> Hope is helps you.
>>
>> Thanks,
>>
>>
>> Zohar Ben Aharon
>> Perfromance Engineer
>> Mellanox Technologies Ltd.
>> Phone:  +972 (74) 723 6829
>> Mobile: +972 (52) 691 1115
>>
>>
>>
>>
>> -----Original Message-----
>> From: Zohar Ben Aharon 
>> Sent: Monday, July 24, 2017 8:41 AM
>> To: 'Nicolas Morey-Chaisemartin' <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>; linux-
>> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Subject: RE: perftest proprietary files
>>
>> Sorry for the late response,
>> ill verify this files propriety and back to you.
>>
>>
>> -----Original Message-----
>> From: Nicolas Morey-Chaisemartin [mailto:NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org] 
>> Sent: Friday, July 21, 2017 11:29 AM
>> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Zohar Ben Aharon <zoharb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
>> Subject: perftest proprietary files
>>
>> Hi,
>>
>> While packaging perftest for SUSE, I discovered that some files have
>> headers  declaring the software as Mellanox proprietary while the
>> COPYING declares LGPL/BSD.
>>
>> The files are:
>> * Makefile.am
>> * Makefile.in
>> * configure.ac
>>
>> Should these headers be dropped ?
>>
>> (I pinged zoharb about this already without much luck. Figured it
>> might be worth a shot here)
>>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
