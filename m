From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: Re: [PATCH v4 05/10] IB/isert: Replace semaphore sem with completion
Date: Fri, 18 Nov 2016 14:40:13 +0530
Message-ID: <CAHv-k__DZEB3HscjORyo48CGaZ4a-ZG+-UXNOJfayLNY8czOoQ@mail.gmail.com>
References: <1477551554-30349-1-git-send-email-binoy.jayan@linaro.org>
 <a267cc5e-4d4f-368e-a159-3eecc2187969@grimberg.me> <CAHv-k__HHRzK7+AZ912GVw9ToxZWMw3OccPqgGt_NBf6+RXdzA@mail.gmail.com>
 <3477625.cZS9dUaHfE@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3477625.cZS9dUaHfE@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Mark Brown <broonie@linaro.org>
Cc: Sagi Grimberg <sagi@grimberg.me>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, Linux kernel mailing list <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Hi Arnd,

On 18 November 2016 at 14:28, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday, November 18, 2016 12:27:32 PM CET Binoy Jayan wrote:
>> Hi Sagi,

> I think you are right. This is behavior is actuallly documented in
> Documentation/scheduler/completion.txt:

Thanking for having a look.

> However, this is fairly unusual behavior and I wasn't immediately aware
> of it either when I read Sagi's reply. While your patch looks correct,
> it's probably a good idea to point out the counting behavior of this
> completion as explicitly as possible, in the changelog text of the patch
> as well as in a code comment and perhaps in the naming of the completion.

Will mention this and resend the patch series.

Thanks,
Binoy
