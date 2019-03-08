From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH] Avoid that check_shl_overflow() triggers a compiler
 warning when building with W=1
Date: Fri, 8 Mar 2019 22:32:41 +0100
Message-ID: <d4980392-af18-34a3-8fce-a5760b637ebe@rasmusvillemoes.dk>
References: <20190307010153.81157-1-bvanassche@acm.org>
 <20190307012417.GU1758@mellanox.com>
 <8a5bd9ae-ebfe-687c-2868-d0f2a610d1e0@acm.org>
 <2c122567-d14b-7867-9230-67f570c13d15@rasmusvillemoes.dk>
 <1552003703.45180.17.camel@acm.org>
 <20190308070107.GE32625@mtr-leonro.mtl.com>
 <ca0d8714-3258-3155-247c-af2d63c28273@rasmusvillemoes.dk>
 <20190308155318.GG32625@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190308155318.GG32625@mtr-leonro.mtl.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Jason Gunthorpe <jgg@mellanox.com>, Kees Cook <keescook@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 08/03/2019 16.53, Leon Romanovsky wrote:
> On Fri, Mar 08, 2019 at 09:09:46AM +0100, Rasmus Villemoes wrote:
>> On 08/03/2019 08.01, Leon Romanovsky wrote:
>>>
>>> Mathematical therm for discrete numbers greater or equal to zero is
>>> "normal numbers".
>>
>> Sorry, WHAT? "Normal" is used and abused for a lot of things in
>> mathematics, but I have never heard it used that way. When attached to
>> the word "number", it means a real number with certain properties
>> related to its digit expansion(s). And then of course there's the
>> isnormal() thing for floating point values in C/computing.
> 
> It is hard to argue with this type of arguments: "never heard -> doesn't
> exist". Luckily enough for me who can't find my fifth grade textbook
> from school, we have Wikipedia which has pointer to ISO standard with
> clear declaration of "normal numbers" as 0,1,2, ....

I'm not really sure how to respond. The word "natural" is not the same
as the word "normal". The wiki page you link to is titled "Natural
number". I'm not going to pay for a copy of that iso standard, but it's
easy enough to google a pdf, which shows a very clear declararation of
"the set of natural numbers" on page 6. Nowhere do any of those sources
talk about "normal numbers".

[As the second paragraph of the wiki page points out, there is not
universal agreement on whether 0 is considered a natural number - though
I'm happy to learn that what I believe to be the right convention is
sanctioned by an ISO standard.]

Rasmus
