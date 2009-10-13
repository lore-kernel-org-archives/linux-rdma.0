From: Brice Goglin <Brice.Goglin@inria.fr>
Subject: Re: [ofa-general] Re: [GIT PULL] please pull ummunotify
Date: Tue, 13 Oct 2009 07:43:15 +0200
Message-ID: <4AD41373.8010108@inria.fr>
References: <adafxalejiq.fsf@cisco.com> <adaab0tej5c.fsf@cisco.com> <1253198976.14935.27.camel@laptop> <adazl8td35u.fsf@cisco.com> <adatyz1d17q.fsf@cisco.com> <20090929171332.GD14405@elf.ucw.cz> <20090930094456.GD24621@elte.hu> <20090930160232.GZ22310@obsidianresearch.com> <20091012181944.GF17138@elte.hu> <20091012193048.GA20313@obsidianresearch.com> <20091012202046.GA7648@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932738AbZJMFpO@vger.kernel.org>
In-Reply-To: <20091012202046.GA7648@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Pavel Machek <pavel@ucw.cz>, Roland Dreier <rdreier@cisco.com>, Peter Zijlstra <peterz@infradead.org>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>, general@lists.openfabrics.org, akpm@linux-foundation.org, torvalds@linux-foundation.org, Jeff Squyres <jsquyres@cisco.com>
List-Id: linux-rdma@vger.kernel.org

Ingo Molnar wrote:
> * Jason Gunthorpe <jgunthorpe@obsidianresearch.com> wrote:
>
>   
>> On Mon, Oct 12, 2009 at 08:19:44PM +0200, Ingo Molnar wrote:
>>
>>     
>>>> After that point the scheme is perfectly lossless.
>>>>         
>>> Well if it can OOM it's not lossless, obviously. You just define 
>>> "event loss" to be equivalent to "Destruction of the universe." ;-)
>>>       
>> It can't OOM once the ummunotify registration is done - when an event 
>> occurs it doesn't allocate any memory and it doesn't loose events.
>>     
>
> Well, it has built-in event loss via the UMMUNOTIFY_FLAG_HINT mechanism: 
> any double events on the same range will cause an imprecise event to be 
> recorded and cause the loss of information.
>   

The target (MPI) application doesn't care about how many events are
coming here. It just needs to know whether something has been
invalidated in the range. If so, it destroy the whole RDMA window
anyway. So it's actually _good_ that multiple events are merged into a
single one: the application only has to process a single event per
partially-invalidated range.

Brice
